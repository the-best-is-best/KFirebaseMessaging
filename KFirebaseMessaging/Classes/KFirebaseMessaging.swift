import FirebaseMessaging
import UserNotifications

@objc public class KFirebaseMessaging: NSObject {
    @objc public static let shared = KFirebaseMessaging() // Singleton instance
    
    @objc public var onNotificationReceived: (([AnyHashable: Any]) -> Void)?
    @objc public var onTokenReceived: ((String?) -> Void)? // Callback for when a new token is received
    @objc public var onNotificationClicked: (([AnyHashable: Any]) -> Void)?

    
    // Initialize Firebase Messaging and Notification Center delegates
    public func initDelegate(notificationDelegate: UNUserNotificationCenterDelegate, messagesDelegate: MessagingDelegate) {
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
    
    // Fetch the current FCM token
    @objc public func getToken(completion: @escaping (String?) -> Void) {
        completion( Messaging.messaging().fcmToken)
    }

    @objc public func subscribeTopic(name: String){
        Messaging.messaging().subscribe(toTopic: name)
    }
    
    @objc public func unsubscribe(name: String){
        Messaging.messaging().unsubscribe(fromTopic: name)
        
    }
    
    @objc public func deleteToken() async{
        do {
            try await Messaging.messaging().deleteToken()

        }
        catch {
            
        }
    }
}
