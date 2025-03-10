package io.gitub.kfirebasemessaging

import io.github.native.kfirebase_messaging.FIRMessaging
import io.github.native.kfirebase_messaging.FIRMessagingDelegateProtocol
import kotlinx.cinterop.ExperimentalForeignApi
import platform.UIKit.UIApplication
import platform.UIKit.registerForRemoteNotifications

actual class AppleKFirebaseMessaging actual constructor() {
    @OptIn(ExperimentalForeignApi::class)
    actual fun init(messagingDelegate: FIRMessagingDelegateProtocol) {
        FIRMessaging.messaging().delegate = messagingDelegate
        FIRMessaging.messaging().autoInitEnabled = true
        UIApplication.sharedApplication.registerForRemoteNotifications()

    }
}