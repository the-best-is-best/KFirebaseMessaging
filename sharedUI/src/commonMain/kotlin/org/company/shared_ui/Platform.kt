package org.company.shared_ui

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform