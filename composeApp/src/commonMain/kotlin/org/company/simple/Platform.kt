package org.company.simple

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform