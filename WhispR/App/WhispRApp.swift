//
//  WhispRApp.swift
//  WhispR
//
//  Created by Amish on 15/07/2023.
//

import SwiftUI
import Firebase

/*
 ------------------------------------------------------------------------------------------------------------------------
 For PHONE AUTHENTICATION you have to do following:
 1. First Enable the phone Auth in Firebase
 2. Add an optional test no in it
 3. Go to Apple Developer to create a key with APN ( if you have one created use that)
 FOR APN SILENT NOTIFICATIONS
 4. Go to project settings -> Cloud Messaging -> Apple app configuration -> There upload the key, give key ID and Team ID ( get from developer account)
 FOR reCAPTCHA
 5. Go into xocde project settings -> info -> under the info go to URL types and add URL from google info.plist -> the url from the google file is reverse client id, givig name to type is optional
 6. Don't forget to add the Push Notification Capability in the xcode
 ------------------------------------------------------------------------------------------------------------------------
 */


@main
struct WhispRApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // Initing the Firebase
    var contacts: ContactsViewModel = ContactsViewModel()
    var authentication: AuthenticationViewModel = AuthenticationViewModel()
    var chats: ChatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(contacts)
                .environment(authentication)
                .environment(chats)
//                .onAppear {
//                    // For requesting user the permission to send notifications
//                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                        if success {
//                            print("All set!")
//                        } else if let error = error {
//                            print(error.localizedDescription)
//                        }
//                    }
//                    print(authentication.getUserID())
//                    print(authentication.getUserPhoneNumber())
//                }
//                .onAppear {
//                    do {
//                        try contacts.getLocalContacts()
//                    } catch {
//                        print(error)
//                    }
//                }
//            ConversationView(user: UserModel(photo: "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW58ZW58MHx8MHx8fDA%3D&w=1000&q=80"), isChatting: .constant(true))
        }
    }
}


// Configuring Firebase APP
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("CONFIGURED")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
}


//// Configuring Firebase APP
//class AppDelegate: NSObject, UIApplicationDelegate {
//    let gcmMessageIDKey = "gcm.message_id"
//    let tokenKey = "eaNlu_fIUUsJqWEHl1RVhK:APA91bFVhxNTZFXJXSnNP28o9ud4lldkP2veNdao1aAsQiuoL8iQMKck8cuHPdSZsnoFoKIDscxfHnUntd6lXyXAFgYKlbFaPzwP66NfDYjJEH5u0v7xWQZ5SQl75e_uDKSFs5hKhEYm"
//    let legacyKey = ""
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        
//        Messaging.messaging().delegate = self
//
//
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        } else {
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//        return true
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("\(#function)")
//        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
// 
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
//    }
//}
//
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//      let dataDict:[String: String] = ["token": fcmToken ?? ""]
//        print("dataDict: ", dataDict) // This token can be used for testing notifications on FCM
//    }
//}
//
//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//  // Receive displayed notifications for iOS 10 devices.
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    let userInfo = notification.request.content.userInfo
//
//    if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//    }
//
//    print(userInfo)
//
//    // Change this to your preferred presentation option
//    completionHandler([[.banner, .badge, .sound]])
//  }
//
////    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
////
////    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//    }
//
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler completionHandler: @escaping () -> Void) {
//    let userInfo = response.notification.request.content.userInfo
//
//    if let messageID = userInfo[gcmMessageIDKey] {
//      print("Message ID from userNotificationCenter didReceive: \(messageID)")
//    }
//
//    print(userInfo)
//
//    completionHandler()
//  }
//}

