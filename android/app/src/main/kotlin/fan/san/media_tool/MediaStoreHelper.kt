package fan.san.media_tool

import android.provider.MediaStore
import android.util.Log
import androidx.loader.content.CursorLoader
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

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
        App.mContext.contentResolver.query(uri,null,
                                           "${MediaStore.MediaColumns.BUCKET_ID}=?",
                                           arrayOf(id.toString()),
                                           null)
            ?.use {
                return it.count
            }
        return 0
    }
}