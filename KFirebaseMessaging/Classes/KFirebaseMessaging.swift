import FirebaseMessaging
import UserNotifications

@objc public class KFirebaseMessaging: NSObject {
    @objc public static let shared = KFirebaseMessaging() // Singleton instance

    // Closures to handle notification data and FCM token updates
    @objc public var onNotificationReceived: (([AnyHashable: Any]) -> Void)?
    @objc public var onTokenReceived: ((String?) -> Void)? // Callback for when a new token is received
    @objc public var onNotificationClicked: (([AnyHashable: Any]) -> Void)?

    // Initialize Firebase Messaging and Notification Center delegates
    @objc public func initDelegate(notificationDelegate: UNUserNotificationCenterDelegate, messagesDelegate: MessagingDelegate) {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        Messaging.messaging().delegate = messagesDelegate
        Messaging.messaging().isAutoInitEnabled = true
    }

    // Request notification authorization
    @objc public func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }

    // Handle successful registration for remote notifications
    @objc public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass the device token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle failure to register for remote notifications
    @objc public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // Fetch the current FCM token
    @objc public func getToken(completion: @escaping (String?) -> Void) {
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
   @objc public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            onTokenReceived?(token)
        }
    }

    // MARK: - User Notifications Delegate methods

    // Called when a notification is received while the app is in the foreground
    @objc  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        onNotificationReceived?(userInfo)
        completionHandler([.alert, .sound, .badge]) // Show notification in the foreground
    }

    // Called when the user interacts with the notification (e.g., taps on it)
    @objc   public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        onNotificationClicked?(userInfo) // Notify app about notification click
        completionHandler()
    }
}
