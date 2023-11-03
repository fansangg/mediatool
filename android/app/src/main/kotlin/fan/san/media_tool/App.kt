package fan.san.media_tool

import android.app.Application
import android.content.Context

/**
 *@author  fansan
 *@version 2023/11/2
 */

class App:Application() {

    companion object{
        lateinit var mContext:App
    }

    override fun onCreate() {
        super.onCreate()
        mContext = this;
    }
}