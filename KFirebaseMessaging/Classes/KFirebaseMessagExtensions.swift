import FirebaseMessaging

extension KFirebaseMessaging {
    
  
    // Handle successful registration for remote notifications
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass the device token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle failure to register for remote notifications
     public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // Fetch the current FCM token
     public func getToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(token)
            }
        }
    }

    // MARK: - MessagingDelegate methods

    // Automatically called when FCM token is refreshed
     public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            KFirebaseMessaging.shared.onTokenReceived?(token)
        }
    }

    // MARK: - User Notifications Delegate methods

    // Called when a notification is received while the app is in the foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        KFirebaseMessaging.shared.onNotificationReceived?(userInfo)
        completionHandler([.alert, .sound, .badge]) // Show notification in the foreground
    }

    // Called when the user interacts with the notification (e.g., taps on it)
     public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        KFirebaseMessaging.shared.onNotificationClicked?(userInfo) // Notify app about notification click
        completionHandler()
    }
}
