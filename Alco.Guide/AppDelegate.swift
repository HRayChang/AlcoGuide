//
//  AppDelegate.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import FirebaseCore
import GooglePlaces
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {

        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey("AIzaSyDQDrokmqKBW0MDKk9usvOyafsUUalOh3g")
        
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error != nil || user == nil {
//              // Show the app's signed-out state.
//            } else {
//              // Show the app's signed-in state.
//                guard let email = user?.profile?.email,
//                      let firstName = user?.profile?.givenName,
//                      let lastName = user?.profile?.familyName else { return }
//            }
//          }
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
