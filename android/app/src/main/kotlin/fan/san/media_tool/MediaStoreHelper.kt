package fan.san.media_tool

import android.provider.MediaStore
import android.util.Log
import androidx.loader.content.CursorLoader

/**
 *@author  fansan
 *@version 2023/11/2
 */

object MediaStoreHelper {

    fun getAllAlbum():ArrayList<AlbumEntity>{
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media.DATA,
        )
        var firstImgData = ""
        var allCount = 0
        val albumList = arrayListOf<AlbumEntity>()
        CursorLoader(App.mContext,uri,projection,null,null,"${MediaStore.Images.Media.DATE_MODIFIED} DESC")
            .loadInBackground()?.let {
                while (it.moveToNext()){
                    val id = it.getLong(it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_ID))
                    val name = it.getString(it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME))
                    allCount++
                    if (albumList.count { list -> list.albumName == name } > 0) continue
                    val imgData = it.getString(it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA))
                    if (it.isFirst){
                        firstImgData = imgData
                    }
                    albumList.add(AlbumEntity(name, imgData, getAlbumImgCount(id)))
                }
            }
        albumList.add(AlbumEntity("所有照片",firstImgData,allCount))
        albumList.sortByDescending {
            it.count
        }
        return albumList
    }

    private fun getAlbumImgCount(id:Long):Int{
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val cursor = CursorLoader(
            App.mContext,
            uri,
            null,
            "${MediaStore.MediaColumns.BUCKET_ID}=?",
            arrayOf(id.toString()),
            null
        ).loadInBackground()

        return cursor?.count?:0
    }
}