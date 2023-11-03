package fan.san.media_tool

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    lateinit var permissionResult: MethodChannel.Result
    private val permissionCallback:(result:MethodChannel.Result) -> Unit = {
        permissionResult = it
        val ret = if (Build.VERSION.SDK_INT >= 33) checkSelfPermission(
            Manifest.permission.READ_MEDIA_IMAGES
        ) else checkSelfPermission(
            Manifest.permission.READ_EXTERNAL_STORAGE
        )
        when{
            ret == PackageManager.PERMISSION_GRANTED -> {
                it.success(1)
            }

            shouldShowRequestPermissionRationale(Manifest.permission.READ_MEDIA_IMAGES) -> {
                it.success(3)
            }

            else -> {
                val permissions = if (Build.VERSION.SDK_INT >= 33) listOf(
                    Manifest.permission.READ_MEDIA_IMAGES,
                    Manifest.permission.READ_MEDIA_VIDEO,
                    Manifest.permission.ACCESS_MEDIA_LOCATION
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
            Log.d("fansangg", "666")
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }){
                permissionResult.success(1)
            }else{
                permissionResult.success(2)
            }
        }
    }
}
