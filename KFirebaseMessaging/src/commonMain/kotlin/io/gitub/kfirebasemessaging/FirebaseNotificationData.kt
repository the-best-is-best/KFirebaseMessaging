package io.gitub.kfirebasemessaging

data class FirebaseNotificationData(
//    val id: Int? = null,
    val title: String? = null,
    val body: String? = null,
    val payload: Map<String, Any?> = emptyMap(),
    val fromTopic: String? = null
)