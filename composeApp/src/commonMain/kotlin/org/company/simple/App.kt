package org.company.simple

import androidx.compose.foundation.layout.padding
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar
import androidx.compose.material3.ElevatedButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import io.gitub.kfirebasemessaging.KFirebaseMessaging
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
@Preview
fun App() {
    val navController = rememberNavController()

    LaunchedEffect(Unit) {
        KFirebaseMessaging.notificationFlow.collect {
            println("notification received is $it")

        }
    }

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