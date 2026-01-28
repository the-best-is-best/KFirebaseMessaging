package org.company.shared_ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ElevatedButton
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import io.gitub.kfirebasemessaging.KFirebaseMessaging

@OptIn(ExperimentalMaterial3Api::class)
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