package fan.san.media_tool

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    private var checkAgain = false
    private val permissionCallback:(Any?) -> Unit = {
        if (it == null) {
            requestMediaPermission()
        }else{
            startActivity(
                Intent(
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.fromParts("package", context.packageName, null)
                )
            )
            checkAgain = true
        }
    }

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
                    Manifest.permission.READ_MEDIA_IMAGES, Manifest.permission.READ_MEDIA_VIDEO, Manifest.permission.ACCESS_MEDIA_LOCATION
                ) else listOf(Manifest.permission.READ_EXTERNAL_STORAGE)

                requestPermissions(permissions.toTypedArray(), 123)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterBrigeHelper.init(flutterEngine,permissionCallback)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 123){
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }){
                FlutterBrigeHelper.sendState(0)
            }else{
                if (shouldShowRequestPermissionRationale(Manifest.permission.READ_MEDIA_IMAGES))
                    FlutterBrigeHelper.sendState(1)
                else FlutterBrigeHelper.sendState(2)
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (checkAgain){
            checkAgain = false
            requestMediaPermission()
        }
    }
}
