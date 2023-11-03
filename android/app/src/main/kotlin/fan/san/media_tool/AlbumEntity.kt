package fan.san.media_tool

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.io.Serializable

/**
 *@author  fansan
 *@version 2023/11/2
 */

data class AlbumEntity(val albumName:String,val firstImg:String,val count:Int): Serializable
