package fan.san.media_tool

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONObject

class MainActivity : FlutterFragmentActivity() {

	private var checkAgain = false
	private var pendingType = -1
	private val pendingList = mutableListOf<Map<String,Any>>()
	private val permissionCallback: (Any?) -> Unit = {
		when (it) {
			null -> {
				requestMediaPermission()
			}
			"" -> {
				startActivity(
					Intent(
						Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
						Uri.fromParts("package", this.packageName, null)
					)
				)
				checkAgain = true
			}
			is Map<*, *> -> {
				val maps = it["datas"] as List<Map<String,Any>>
				val uriList = maps.map { map ->
					Uri.parse(map["uri"] as String)
				}
				pendingType = it["type"] as Int
				pendingList.clear()
				pendingList.addAll(maps)

				val pendingIntent = MediaStore.createWriteRequest(
					contentResolver, uriList
				)
				writePermission.launch(IntentSenderRequest.Builder(pendingIntent).build())
			}
		}
	}
	private lateinit var writePermission: ActivityResultLauncher<IntentSenderRequest>

	private lateinit var mediaPermission: ActivityResultLauncher<Array<String>>

	private fun requestMediaPermission() {
		val ret = if (Build.VERSION.SDK_INT >= 33) checkSelfPermission(
			Manifest.permission.READ_MEDIA_IMAGES
		) else checkSelfPermission(
			Manifest.permission.READ_EXTERNAL_STORAGE
		)
		when (ret) {
			PackageManager.PERMISSION_GRANTED -> {
				FlutterBrigeHelper.sendState(0)
			}

			else -> {
				val permissions = if (Build.VERSION.SDK_INT >= 33) listOf(
					Manifest.permission.READ_MEDIA_IMAGES,
					Manifest.permission.READ_MEDIA_VIDEO,
					Manifest.permission.ACCESS_MEDIA_LOCATION
				) else listOf(Manifest.permission.READ_EXTERNAL_STORAGE)


				mediaPermission.launch(permissions.toTypedArray())
			}
		}
	}

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		writePermission = registerForActivityResult(ActivityResultContracts.StartIntentSenderForResult()) {
			if (it.resultCode == RESULT_OK) {
				when (pendingType) {
					1 -> {
						MediaStoreHelper.fixLastModified(pendingList)
					}
					2 -> {
						MediaStoreHelper.fixTakenTime(pendingList)
					}
					else -> {

					}
				}
			} else {
				val jsonObject = JSONObject()
				jsonObject.put("tag","permissionDenied")
				FlutterBrigeHelper.sendEvent(jsonObject.toString())
			}
		}

		mediaPermission = registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) {
			if (it.values.all { true }) {
				FlutterBrigeHelper.sendState(0)
			} else {
				val ret = if (Build.VERSION.SDK_INT >= 33) {
					shouldShowRequestPermissionRationale(Manifest.permission.READ_MEDIA_IMAGES)
				} else shouldShowRequestPermissionRationale(Manifest.permission.READ_EXTERNAL_STORAGE)
				if (ret) FlutterBrigeHelper.sendState(1)
				else FlutterBrigeHelper.sendState(2)
			}
		}
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		FlutterBrigeHelper.init(flutterEngine, permissionCallback)
	}

    override fun onResume() {
        super.onResume()
        if (checkAgain){
            checkAgain = false
            requestMediaPermission()
        }
    }
}
