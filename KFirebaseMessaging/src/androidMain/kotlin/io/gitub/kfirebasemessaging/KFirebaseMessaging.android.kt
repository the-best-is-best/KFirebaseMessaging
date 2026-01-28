package io.gitub.kfirebasemessaging

import android.os.Bundle
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import io.tbib.klocal_notification.LocalNotification
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

actual object KFirebaseMessaging {
    private fun firebaseMessaging() = FirebaseMessaging.getInstance()
  internal  val tokenFlowInternal = MutableSharedFlow<String?>(replay = 1, extraBufferCapacity = 1)
    private val _notificationFlow =
        MutableSharedFlow<FirebaseNotificationData>(replay = 1, extraBufferCapacity = 1)

    init {
        firebaseMessaging().token.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                tokenFlowInternal.tryEmit(task.result)
            } else {
                tokenFlowInternal.tryEmit(null)
            }
        }

    }


    actual val tokenFlow: SharedFlow<String?> = tokenFlowInternal


    actual suspend fun getToken(): Result<String?> {
        return suspendCancellableCoroutine { cont ->

            firebaseMessaging().token.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    cont.resume(Result.success(task.result))
                } else {
                    cont.resume(
                        Result.failure(
                            task.exception ?: Exception("Failed to get token")
                        )
                    )
                }
            }
        }
    }


    actual fun deleteToken() {
        FirebaseMessaging.getInstance().deleteToken()
    }


    actual suspend fun subscribeTopic(name: String): Result<Boolean> {
        return suspendCancellableCoroutine { cont ->
            FirebaseMessaging.getInstance().subscribeToTopic(name)
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {
                        cont.resume(Result.success(true))
                    } else {
                        cont.resume(Result.failure(Exception(task.exception)))
                    }
                }
        }
    }

    actual suspend fun unsubscribeTopic(name: String): Result<Boolean> {
        return suspendCancellableCoroutine { cont ->

            FirebaseMessaging.getInstance().unsubscribeFromTopic(name)
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {
                        cont.resume(Result.success(true))
                    } else {
                        cont.resume(Result.failure(Exception(task.exception)))
                    }
                }
        }
    }



    fun notifyNotificationClicked(dataBundle: Bundle) {
        if (!dataBundle.isEmpty) {
            // Create a map to store the key-value pairs
            val dataMap = mutableMapOf<String, String>()

            // Iterate over the keys in the Bundle (extras)
            for (key in dataBundle.keySet()) {
                // Get the value associated with the key
                val value = dataBundle.getString(key)
                // Add to the map if the value is not null
                if (value != null) {
                    dataMap[key] = value
                }
            }

            // Convert the map to a JSON string using Gson
            val jsonString = Gson().toJson(dataMap)
            LocalNotification.notifyPayloadListeners(jsonString)

        }
    }

    internal fun emitNotification(data: FirebaseNotificationData) {
        _notificationFlow.tryEmit(data)
    }

    actual val notificationFlow: SharedFlow<FirebaseNotificationData> = _notificationFlow


}