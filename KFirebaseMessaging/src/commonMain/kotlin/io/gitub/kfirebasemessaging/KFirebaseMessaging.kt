package io.gitub.kfirebasemessaging

import kotlinx.coroutines.flow.SharedFlow

expect class KFirebaseMessaging() {
    companion object {
        fun instance(): KFirebaseMessaging
    }
    // Set a listener for the token
    val tokenFlow: SharedFlow<String?>

    // Get the current token
    suspend fun getToken(): Result<String?>

    fun deleteToken()

    // Subscribe to a topic
    suspend fun subscribeTopic(name: String): Result<Boolean>

    // Unsubscribe from a topic
    suspend fun unsubscribeTopic(name: String): Result<Boolean>


}