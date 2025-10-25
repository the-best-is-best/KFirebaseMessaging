package io.gitub.kfirebasemessaging

import io.github.native.kfirebase_messaging.FIRMessaging
import io.github.native.kfirebase_messaging.FIRMessagingDelegateProtocol
import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

@OptIn(ExperimentalForeignApi::class)
actual object KFirebaseMessaging {
    private val _tokenFlow = MutableSharedFlow<String?>(replay = 1, extraBufferCapacity = 1)

    private val _notificationFlow =
        MutableSharedFlow<FirebaseNotificationData>(replay = 1, extraBufferCapacity = 1)


    fun notifyTokenListener(token: String?) {
        _tokenFlow.tryEmit(token)
    }


    actual suspend fun getToken(): Result<String?> {
        return suspendCancellableCoroutine { cont ->
            try {
                cont.resume(Result.success(FIRMessaging.messaging().FCMToken)) { cause, _, _ ->

                }

            } catch (e: Exception) {
                cont.resume(Result.failure(e))
            }
        }
    }

    actual val tokenFlow: SharedFlow<String?> = _tokenFlow

    actual fun deleteToken() {
        FIRMessaging.messaging().deleteTokenWithCompletion { }

    }


    actual suspend fun subscribeTopic(name: String): Result<Boolean> {
        return suspendCancellableCoroutine { cont ->

            try {
                FIRMessaging.messaging().subscribeToTopic(name)

                cont.resume(Result.success(true))
            } catch (e: Exception) {
                cont.resume(Result.failure(Exception(e)))
            }
        }
    }

    actual suspend fun unsubscribeTopic(name: String): Result<Boolean> {
        return suspendCancellableCoroutine { cont ->

            try {
                FIRMessaging.messaging().unsubscribeFromTopic(name)
                cont.resume(Result.success(true))
            } catch (e: Exception) {
                cont.resume(Result.failure(Exception(e)))
            }
        }
    }

    actual val notificationFlow: SharedFlow<FirebaseNotificationData> = _notificationFlow

    fun notifyNotificationListener(data: FirebaseNotificationData) {
        _notificationFlow.tryEmit(data)
    }

}

@OptIn(ExperimentalForeignApi::class)
expect class AppleKFirebaseMessaging() {
    fun init(messagingDelegate: FIRMessagingDelegateProtocol)
}