//
//  AppDelegate.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//test

import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ParseSwift.initialize(applicationId: "YnERzK1pPzSarWbUYSE8sUzAeE6nok4MW16FD5eA",
                              clientKey: "VPr0raUzUcgE1Ll7Iwcf3V9UrSoNjwex8iUSqrqV",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)
        
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

