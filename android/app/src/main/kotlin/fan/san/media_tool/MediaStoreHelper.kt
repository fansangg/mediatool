package fan.san.media_tool

import android.content.ContentUris
import android.graphics.Bitmap
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import java.io.File
import java.io.FileOutputStream
import java.io.FileWriter

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
			MediaStore.Files.FileColumns.MEDIA_TYPE
		)
		val selection =
			"(${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE} OR ${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO}) AND (${MediaStore.Files.FileColumns.DATE_TAKEN} IS NULL OR ABS(${MediaStore.Files.FileColumns.DATE_MODIFIED} * 1000 - ${MediaStore.Files.FileColumns.DATE_TAKEN}) > 60 * 1000)"



		App.mContext.contentResolver.query(
			uri, projection, selection, null, "${MediaStore.Images.Media.DATE_MODIFIED} DESC"
		)?.use {
			Log.d("fansangg", "cursor count == ${it.count}")
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

						val taken = it.getLong(takenIndex)
						val modified = it.getLong(modifiedIndex)
						val data = it.getString(dataIndex)
						val added = it.getLong(addedIndex)
						val width = it.getInt(widthIndex)
						val height = it.getInt(heightIndex)
						val size = it.getLong(sizeIndex)
						val fileName = it.getString(nameIndex)
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
						)						//if (taken <= 0L || abs(modified * 1000 - taken) > 1000 * 60 )
						resultList.add(mapData)
					} while (it.moveToNext())
				} catch (e: Exception) {
					Log.d("fansangg", "e == ${e.message}")
				}
			}
		}
		return resultList
	}

	fun getVideoThumbnail(uri:Uri):String{
		val fileName = "cache_${uri.toString().substring(uri.toString().lastIndexOf("/") + 1)}"
		try {
			val cache = File(App.mContext.cacheDir,fileName)
			if (!cache.exists()){
				val bitmap = App.mContext.contentResolver.loadThumbnail(uri, Size(300,300),null)
				val outputStream = FileOutputStream(cache)
				bitmap.compress(Bitmap.CompressFormat.PNG,100,outputStream)
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
}