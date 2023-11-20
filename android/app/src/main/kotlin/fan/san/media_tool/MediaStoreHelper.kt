package fan.san.media_tool

import android.content.ContentUris
import android.graphics.Bitmap
import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import androidx.exifinterface.media.ExifInterface
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.text.DecimalFormat
import kotlin.math.pow
import kotlin.math.sqrt

/**
 *@author  fansan
 *@version 2023/11/2
 */

object MediaStoreHelper {

    fun getAllAlbum(): ArrayList<AlbumEntity> {
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media.DATA,
        )
        var firstImgData = ""
        var allCount = 0
        val albumList = arrayListOf<AlbumEntity>()
        App.mContext.contentResolver.query(
            uri,
            projection,
            null,
            null,
            "${MediaStore.Images.Media.DATE_MODIFIED} DESC"
        )?.use {
                if (it.moveToFirst()) {
                    do {
                        val id =
                            it.getLong(it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_ID))
                        val name =
                            it.getString(it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME))
                        allCount++
                        if (albumList.count { list -> list.albumName == name } > 0) continue
                        val imgData =
                            it.getString(it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA))
                        if (it.isFirst) {
                            firstImgData = imgData
                        }
                        albumList.add(AlbumEntity(name, imgData, getAlbumImgCount(id)))
                    } while (it.moveToNext())
	                albumList.add(AlbumEntity("所有照片", firstImgData, allCount))
	                albumList.sortByDescending { entity ->
		                entity.count
	                }
                }
        }
	    return albumList
    }

	private fun getAlbumImgCount(id: Long): Int {
		val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
		App.mContext.contentResolver.query(
			uri, null, "${MediaStore.MediaColumns.BUCKET_ID}=?", arrayOf(id.toString()), null
		)?.use {
			return it.count
		}
		return 0
	}

	fun getNotSync(): List<Map<String, Any>> {
		val resultList = mutableListOf<Map<String, Any>>()
		val uri = MediaStore.Files.getContentUri("external")
		val projection = arrayOf(
			MediaStore.Images.Media._ID,
			MediaStore.Images.Media.DISPLAY_NAME,
			MediaStore.Images.Media.DATA,
			MediaStore.Images.Media.WIDTH,
			MediaStore.Images.Media.HEIGHT,
			MediaStore.Images.Media.DATE_ADDED,
			MediaStore.Images.Media.DATE_MODIFIED,
			MediaStore.Images.Media.DATE_TAKEN,
			MediaStore.Images.Media.SIZE,
			MediaStore.Files.FileColumns.MEDIA_TYPE,
			MediaStore.Video.Media.ORIENTATION,
		)
		val selection =
			"(${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE} OR ${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO}) AND (${MediaStore.Files.FileColumns.DATE_TAKEN} IS NULL OR ABS(${MediaStore.Files.FileColumns.DATE_MODIFIED} * 1000 - ${MediaStore.Files.FileColumns.DATE_TAKEN}) > 60 * 1000)"



		App.mContext.contentResolver.query(
			uri, projection, selection, null, "${MediaStore.Images.Media.DATE_MODIFIED} DESC"
		)?.use {
			if (it.moveToFirst()) {
				try {
					do {
						val dataIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
						val takenIndex =
							it.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_TAKEN)
						val modifiedIndex =
							it.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_MODIFIED)
						val addedIndex =
							it.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_ADDED)
						val widthIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.WIDTH)
						val heightIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.HEIGHT)
						val sizeIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.SIZE)
						val nameIndex =
							it.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME)
						val idIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
						val mediaTypeIndex =
							it.getColumnIndexOrThrow(MediaStore.Files.FileColumns.MEDIA_TYPE)
						val orientationIndex = it.getColumnIndexOrThrow(MediaStore.Video.Media.ORIENTATION)

						val taken = it.getLong(takenIndex)
						val modified = it.getLong(modifiedIndex)
						val data = it.getString(dataIndex)
						val added = it.getLong(addedIndex)
						val width = it.getInt(widthIndex)
						val height = it.getInt(heightIndex)
						val size = it.getLong(sizeIndex)
						val fileName = it.getString(nameIndex)
						val orientation = it.getInt(orientationIndex)
						val id = it.getLong(idIndex)
						val mediaType = it.getInt(mediaTypeIndex)
						val fileUri = ContentUris.withAppendedId(uri, id)
						val mapData = mapOf(
							"fileName" to fileName,
							"fileSize" to size,
							"width" to width,
							"height" to height,
							"path" to data,
							"type" to mediaType,
							"taken" to taken,
							"lastModify" to modified,
							"addTime" to added,
							"uri" to fileUri.toString(),
							"orientation" to orientation,
							"thumbnail" to getVideoThumbnail(fileUri,mediaType,fileName)
						)
						resultList.add(mapData)
					} while (it.moveToNext())
				} catch (e: Exception) {
					Log.d("fansangg", "e == ${e.message}")
				}
			}
		}
		return resultList
	}

	private fun getVideoThumbnail(uri:Uri, mediaType:Int, fileName:String):String{
		if (mediaType == 1) return ""
		try {
			val cache = File(App.mContext.cacheDir,"$fileName.cache")
			if (!cache.exists()){
				val bitmap = App.mContext.contentResolver.loadThumbnail(uri, Size(300,300),null)
				val outputStream = FileOutputStream(cache)
				bitmap.compress(Bitmap.CompressFormat.PNG,75,outputStream)
				outputStream.flush()
				outputStream.close()
			}

			return cache.absolutePath
		} catch (e: Exception) {
			e.printStackTrace()
			Log.d("fansangg", "写入失败")
		}

		return ""
	}

	fun getVideoCover(path: String): ByteArray {
		val mmr = MediaMetadataRetriever()
		mmr.setDataSource(path)
		val bitmap = mmr.getFrameAtTime(2000 * 1000 * 60)
		val outputStream = ByteArrayOutputStream()
		bitmap?.compress(Bitmap.CompressFormat.PNG,75,outputStream)
		return outputStream.toByteArray()
	}

	fun getExif(path: String):Map<String,String> {
		val exifInterface = ExifInterface(path)
		val model = exifInterface.getAttribute(ExifInterface.TAG_MODEL)
		val latitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE_REF)
		val altitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_ALTITUDE_REF)
		val longitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF)
		val longitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE)
		val latitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE)
		val altitude = exifInterface.getAttributeDouble(ExifInterface.TAG_GPS_ALTITUDE, 0.0)
		val iso = exifInterface.getAttribute(ExifInterface.TAG_PHOTOGRAPHIC_SENSITIVITY)
		val aperture = exifInterface.getAttributeDouble(ExifInterface.TAG_MAX_APERTURE_VALUE, 0.0)
		val brightnessd = exifInterface.getAttributeDouble(ExifInterface.TAG_BRIGHTNESS_VALUE, 0.0)
		val digitalZoomRatio = exifInterface.getAttribute(ExifInterface.TAG_DIGITAL_ZOOM_RATIO)
		val exposureTime = exifInterface.getAttributeDouble(ExifInterface.TAG_EXPOSURE_TIME, 0.0)
		val exposureBias =
			exifInterface.getAttributeDouble(ExifInterface.TAG_EXPOSURE_BIAS_VALUE, 0.0)
		val foclLength35mm = exifInterface.getAttribute(ExifInterface.TAG_FOCAL_LENGTH_IN_35MM_FILM)
		val flash = exifInterface.getAttribute(ExifInterface.TAG_FLASH)
		val focalLength = exifInterface.getAttributeDouble(ExifInterface.TAG_FOCAL_LENGTH, 0.0)
		val whiteBalance = exifInterface.getAttributeInt(ExifInterface.TAG_WHITE_BALANCE,0)

		val map = mutableMapOf<String, String>()
		map["器材"] = model ?: ""
		map["ISO"] = iso ?: ""
		map["亮度值"] = brightnessd.toString()
		map["数码变焦比"] = digitalZoomRatio ?: ""
		map["曝光时间"] = if (exposureTime == 0.0) "" else "1/${(1 / exposureTime).toInt()}"
		map["曝光补偿"] = "$exposureBias ev"
		map["35mm等效焦距"] = foclLength35mm ?: ""
		map["闪光灯"] = if (flash == null) "" else if (flash == "0") "未开启" else "已开启"
		map["焦距"] = if (focalLength == 0.0) "" else focalLength.toString()
		map["光圈值"] = if (aperture == 0.0) "" else "ƒ${getAperture(aperture)}"
		map["白平衡"] = if (whiteBalance == 0) "自动" else "手动"
		map["位置"] = getLocation(latitude?:"",latitudeRef?:"",longitude?:"",longitudeRef?:"",altitude)

		return map
		/*Log.d(
			"fansangg",
			"model == $model,digitalZoomRatio == $digitalZoomRatio,exposureTime == $exposureTime,Iso == $iso,latitudeRef == $latitudeRef,latitude == $latitude,longitudeRef == $longitudeRef,longitude == $longitude,altitudeRef == $altitudeRef,altitude == $altitude,foclLength35mm == $foclLength35mm,exposureBias == $exposureBias,flash == $flash,focalLength == $focalLength,brightnessd == $brightnessd,aperture == $aperture"
		)*/
	}

	private fun getAperture(aperture: Double): String {
		val decimalFormat = DecimalFormat("#.${"#".repeat(1)}")
		return decimalFormat.format(sqrt(2.0).pow(aperture))
	}

	private fun getLocation(
		latitude: String,
		latitudeRef: String,
		longitude: String,
		longitudeRef: String,
		altitude: Double
	):String {
		try {
			val latitudeArray = latitude.split(",")
			val longitudeArray = longitude.split(",")
			val lat1 = latitudeArray[0].split("/")
			val lat2 = latitudeArray[1].split("/")
			val lat3 = latitudeArray[2].split("/")
			val latRet1 = formatDecimal(lat1[0].toDouble() / lat1[1].toDouble())
			val latRet2 = formatDecimal(lat2[0].toDouble() / lat2[1].toDouble())
			val latRet3 = formatDecimal(lat3[0].toDouble() / lat3[1].toDouble())

			val lon1 = longitudeArray[0].split("/")
			val lon2 = longitudeArray[1].split("/")
			val lon3 = longitudeArray[2].split("/")
			val lonRet1 = formatDecimal(lon1[0].toDouble() / lon1[1].toDouble())
			val lonRet2 = formatDecimal(lon2[0].toDouble() / lon2[1].toDouble())
			val lonRet3 = formatDecimal(lon3[0].toDouble() / lon3[1].toDouble())

			return "$latRet1 deg $latRet2' $latRet3\" $latitudeRef $lonRet1 deg $lonRet2' $lonRet3\" $longitudeRef ${formatDecimal(altitude)} m Above Sea Level"
		} catch (e: Exception) {
			Log.d("fansangg", "${e.message}")
		}

		return ""
	}

	fun getVideoInfo(path: String):Map<String,String>{

		val mediaMetadataRetriever = MediaMetadataRetriever()
		mediaMetadataRetriever.setDataSource(path)
		val location = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_LOCATION)
		val bitrate = "${formatDecimal((mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE)?:"0").toInt() / 1000.0)} kb/s"
		val duration = formatDuration((mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: "0").toLong())

		var framerate = ""
		var rotation = ""

		var videoCodec = ""
		var audioCodec = ""

		val mediaExtractor = MediaExtractor()
		mediaExtractor.setDataSource(path)
		for (i in 0 until mediaExtractor.trackCount){
			val format = mediaExtractor.getTrackFormat(i)
			val mime = format.getString(MediaFormat.KEY_MIME)
			if (mime?.startsWith("video") == true){
				framerate = format.getInteger(MediaFormat.KEY_FRAME_RATE,0).toString()
				rotation = format.getInteger(MediaFormat.KEY_ROTATION,-1).toString()
				videoCodec = when(mime.split("/")[1]){
					"avc" -> "H264"
					"hevc" -> "HEVC"
					"vp9" -> "VP9"
					"av1" -> "AV1"
					"mp4" -> "MP4"
					"mpeg" -> "MPEG"
					"x-msvideo" -> "AVI"
					else -> "未知编码器"
				}
			}

			if (mime?.startsWith("audio") == true){
				audioCodec = when(mime.split("/")[1]){
					"mp4a-latm" -> "AAC"
					"mp3" -> "MP3"
					"wab" -> "WAV"
					"amr" -> "ARM"
					"flac" -> "FLAC"
					else -> "未知编码器"
				}
			}
		}

		val map = mutableMapOf<String,String>()
		map["时长"] = duration
		map["比特率"] = bitrate
		map["FPS"] = framerate
		map["角度"] = rotation?:""
		map["视频编码"] = videoCodec
		map["音频编码"] = audioCodec
		map["位置"] = location?:""

		return map

		/*Log.d("fansangg", "duration == $duration,bitrate == $bitrate,framerate == $framerate,composer == $composer,location == $location,rotation == $rotation,videoCodec == $videoCodec,audioCodec == $audioCodec")*/
	}

	private fun formatDecimal(number: Double): String {
		return if (number % 1 == 0.0) {
			String.format("%.0f", number)
		} else {
			String.format("%.2f", number)
		}
	}

	private fun formatDuration(duration: Long): String {
		val seconds = duration / 1000
		val minutes = seconds / 60
		val hours = minutes / 60
		val remainingMinutes = minutes % 60
		val remainingSeconds = seconds % 60
		return String.format("%02d:%02d:%02d", hours, remainingMinutes, remainingSeconds)
	}
}