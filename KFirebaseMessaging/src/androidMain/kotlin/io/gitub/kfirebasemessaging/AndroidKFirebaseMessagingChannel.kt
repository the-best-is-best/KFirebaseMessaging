package io.gitub.kfirebasemessaging

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.startup.Initializer
import io.gitub.kfirebasemessaging.AndroidKFirebaseMessagingChannel.Companion.applicationContext

class ApplicationContextInitializer : Initializer<Context> {
    override fun create(context: Context): Context = context.also {
        applicationContext = it.applicationContext
    }

    override fun dependencies(): List<Class<out Initializer<*>>> = emptyList()
}

class AndroidKFirebaseMessagingChannel {
    companion object {
        internal lateinit var applicationContext: Context

        internal var icon: String? = null
        internal var id: String? = null
    }


    // Initialize Notification Channel
    fun initChannel(id: String, name: String, icon: String, channelDesc: String? = null) {
        Companion.icon = icon
        Companion.id = id
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                id,
                name,
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = channelDesc ?: "Default channel description"
            }


            val notificationManager =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(notificationChannel)
        }
    }


}