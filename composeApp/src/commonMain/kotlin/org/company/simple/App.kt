package org.company.simple

import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar
import androidx.compose.material3.ElevatedButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import io.github.firebase_core.KFirebaseCore
import io.gitub.kfirebasemessaging.KFirebaseMessaging
import io.tbib.klocal_notification.LocalNotification
import io.tbib.klocal_notification.LocalNotificationRequestAuthorization
import kotlinx.coroutines.launch
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
@Preview
fun App() {
    val navController = rememberNavController()

    Scaffold(
        topBar = {
            TopAppBar(title = {
                Text("Compose App")
            })
        },
    ) { padding ->


        NavHost(
            modifier = Modifier.padding(padding),
            navController = navController,

            startDestination = "/" // Start with the home screen
        ) {
            composable("/") {
                ElevatedButton(
                    onClick = {
                        navController.navigate("second")
                    }
                ) {
                    Text("Go to second screen")
                }
            }
            composable("second") {
                AppScreen()
            }


        }
    }
}