//
//  AppDelegate.swift
//  CarTracker
//
//  Created by VietAnh on 10/15/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = WelcomeVC()
        let navi = BaseNavigationController(rootViewController: vc)
        navi.navigationBar.isTranslucent = false
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
//        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
//        let mqtt = MQTTConnectionManager.shared();
//        mqtt.connect()
//        let settings = UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // Get on-disk location of the default Realm
        let realm = try! Realm()
        print("Realm is located at:", realm.configuration.fileURL!)
        return true
    }
    
    //background
    func applicationDidEnterBackground(_ application: UIApplication) {
//        RKMQTTConnectionManager.setDelegate(delegate: self)
        print("applicationDidEnterBackground")
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        completionHandler(UIBackgroundFetchResult.newData)
//        print("performFetchWithCompletionHandler")
//        print("fetching")
//        let mqtt = MQTTConnectionManager.shared();
//        print(mqtt.isConnect())
//        // TODO: further examine whether wait should be 4 or 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            print("finished")
//            completionHandler(UIBackgroundFetchResult.newData)
//        })
    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

