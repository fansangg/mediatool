package fan.san.media_tool

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 *@author  fansan
 *@version 2023/11/2
 */
object FlutterBrigeHelper {

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var toFlutterMethodChannel: MethodChannel
    private lateinit var nativeChannel: MethodChannel
    fun init(flutterEngine: FlutterEngine, callBack:(MethodChannel.Result) -> Unit) {
        this.flutterEngine = flutterEngine
        toFlutterMethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter")
        nativeChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "native")
        listenFlutter(callBack)
    }

    private fun listenFlutter(callBack:(MethodChannel.Result) -> Unit) {
        nativeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getPermission" -> {
                    callBack.invoke(result)
                }

                "getAllAlbum" -> {
                    val list = MediaStoreHelper.getAllAlbum()
                    val mapList = list.map {
                        mapOf(
                            "albumName" to it.albumName,
                            "count" to it.count,
                            "firstImg" to it.firstImg
                        )
                    }
                    result.success(mapList)
                }
            }
        }
    }
}