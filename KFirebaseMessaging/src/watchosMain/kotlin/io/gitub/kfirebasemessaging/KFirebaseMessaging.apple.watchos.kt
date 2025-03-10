package io.gitub.kfirebasemessaging

import io.github.native.kfirebase_messaging.FIRMessaging
import io.github.native.kfirebase_messaging.FIRMessagingDelegateProtocol
import kotlinx.cinterop.ExperimentalForeignApi
import platform.WatchKit.WKExtension

actual class AppleKFirebaseMessaging actual constructor() {
    @OptIn(ExperimentalForeignApi::class)
    actual fun init(messagingDelegate: FIRMessagingDelegateProtocol) {
        FIRMessaging.messaging().delegate = messagingDelegate
        FIRMessaging.messaging().autoInitEnabled = true
        WKExtension.sharedExtension().registerForRemoteNotifications()

    }
}