package org.company.app.androidApp

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge

import io.github.firebase_core.AndroidKFirebaseCore
import io.gitub.kfirebasemessaging.AndroidKFirebaseMessagingChannel
import io.gitub.kfirebasemessaging.KFirebaseMessaging
import io.tbib.klocal_notification.AndroidKMessagingChannel
import org.company.shared_ui.App

class AppActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        AndroidKFirebaseCore.initialization(this)
        AndroidKMessagingChannel.initialization(this)
        AndroidKFirebaseMessagingChannel().initChannel(
            "fcm",
            "fcm notification",
            "ic_notification"
        )

        setContent {
            App()
        }
        val dataBundle = intent.extras
        if (dataBundle != null) {
            KFirebaseMessaging.notifyNotificationClicked(dataBundle)

        }

    }

    // for get data fcm in app background
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val dataBundle = intent.extras
        if (dataBundle != null) {
            KFirebaseMessaging.notifyNotificationClicked(dataBundle)

        }
    }
}


