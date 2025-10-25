import ComposeApp
import Firebase
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,
  MessagingDelegate
{
    
    var window: UIWindow?
    
    // This function is called when the app starts
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Firebase initialization
        FirebaseApp.configure()
        
        LocalNotification.shared.doInit(userNotificationCenterDelegate: self)
        AppleKFirebaseMessaging().doInit(messagingDelegate: self)
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.rootViewController = MainViewControllerKt.MainViewController()
            window.makeKeyAndVisible()
        }
        // not need add this now
        if let userInfo = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            LocalNotification.shared.notifyPayloadListeners(data: userInfo)
            
        }
        
        return true
    }


    // Handle failure to register for remote notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Handle notification when the app is in the foreground
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS Token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    

    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        let title = notification.request.content.title
        let body = notification.request.content.body

        let fromTopic = userInfo["from"] as? String

        let payload = userInfo.reduce(into: [String: Any]()) { result, entry in
            if let key = entry.key as? String {
                result[key] = entry.value
            }
        }

        let data = FirebaseNotificationData(
            title: title,
            body: body,
            payload: payload,
            fromTopic: fromTopic
        )

        KFirebaseMessaging.shared.notifyNotificationListener(data: data)
        completionHandler([.alert, .sound, .badge]) // Show notification in the foreground
    }
    
    // Handle notification when the user interacts with it (taps on the notification)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        LocalNotification.shared.notifyPayloadListeners(data: userInfo)
        completionHandler()
    }
    
    // Firebase Messaging delegate method for receiving FCM token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        KFirebaseMessaging().notifyTokenListener(token: fcmToken)
    }
}
