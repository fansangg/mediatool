package fan.san.media_tool

import android.net.Uri
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

/**
 *@author  fansan
 *@version 2023/11/2
 */
object FlutterBrigeHelper {

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var nativeChannel: MethodChannel
    var permissionSink:EventChannel.EventSink? = null
    var eventSink:EventChannel.EventSink? = null
    fun init(flutterEngine: FlutterEngine, callBack:(Any?) -> Unit) {
        this.flutterEngine = flutterEngine
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "permission")
        .setStreamHandler(object:EventChannel.StreamHandler{
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                permissionSink = events
            }

            override fun onCancel(arguments: Any?) {
	            permissionSink = null
            }

        })
	    EventChannel(flutterEngine.dartExecutor.binaryMessenger, "event")
		    .setStreamHandler(object:EventChannel.StreamHandler{
			    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
				    eventSink = events
			    }

			    override fun onCancel(arguments: Any?) {
				    eventSink = null
			    }

		    })
        nativeChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "native")
        listenFlutter(callBack)
    }

    fun sendState(state:Int){
	    permissionSink?.success(state)
    }

    private fun listenFlutter(callBack:(Any?) -> Unit) {
        nativeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getPermission" -> {
                    callBack.invoke(null)
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

                "gotoSettings" -> {
                    callBack.invoke("")
                    result.notImplemented()
                }

	            "checkNoSync" -> {
					val list = MediaStoreHelper.getNotSync()
		            result.success(list)
				}

	            "getVideoThumbnail" -> {
		            val array = MediaStoreHelper.getVideoCover(call.arguments as String)
		            if (array.isNotEmpty())
		                result.success(array)
		            else
						result.notImplemented()
				}
            }
        }
    }
}