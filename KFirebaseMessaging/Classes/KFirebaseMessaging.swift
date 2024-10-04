import FirebaseMessaging
import UserNotifications

@objc public class KFirebaseMessaging: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    @objc public static let shared = KFirebaseMessaging() // Singleton instance

    // Closures to handle notification data and FCM token updates
    @objc public var onNotificationReceived: (([AnyHashable: Any]) -> Void)?
    @objc public var onTokenReceived: ((String?) -> Void)? // Callback for when a new token is received

    private override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
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

    // This method gets called when the app successfully registers for remote notifications
    @objc public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken // Pass the device token to Firebase Messaging
       
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    // Get the current FCM token
    @objc public func getToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error.localizedDescription)")
                completion(nil)
            } else if let token = token {
                print("FCM registration token: \(token)")
                completion(token)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - MessagingDelegate methods

    // Automatically called when FCM token is refreshed
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {


        // You can also send the token to your server here
        if let token = fcmToken {
            onTokenReceived?(token)
        }
    }

    
    // MARK: - User Notifications Delegate methods

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Received notification while app is in the foreground: \(userInfo)")
        completionHandler([.alert, .sound, .badge])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("User clicked on notification: \(userInfo)")
        onNotificationReceived?(userInfo)
        completionHandler()
    }
}
