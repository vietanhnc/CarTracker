//
//  AppDelegate.swift
//  CarTracker
//
//  Created by VietAnh on 10/15/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
import Localize_Swift
import IQKeyboardManagerSwift
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = WelcomeVC()
        let navi = BaseNavigationController(rootViewController: vc)
        navi.navigationBar.isTranslucent = false
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        Localize.setCurrentLanguage("vi")
        IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch.
        //        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        //        let mqtt = MQTTConnectionManager.shared();
        //        mqtt.connect()
        //        let settings = UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil)
        //        UIApplication.shared.registerUserNotificationSettings(settings)
        
        //migrate
        var configuration = Realm.Configuration(
            schemaVersion: 9,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    
                    // if just the name of your model's property changed you can do this
                    //                    migration.renameProperty(onType: CarDevice.className(), from: "deviceDateExpire", to: "expiredGuaranteeDate")
                    // if you want to fill a new property with some values you have to enumerate
                    // the existing objects and set the new value
                    //                    migration.enumerateObjects(ofType: UserInfo.className()) { oldObject, newObject in
                    //                        let text = oldObject!["text"] as! String
                    //                        newObject!["textDescription"] = "The title is \(text)"
                    //                    }
                    
                    // if you added a new property or removed a property you don't
                    // have to do anything because Realm automatically detects that
                }
            }
        )
        GMSServices.provideAPIKey("AIzaSyDsjm4lVNumEv6s7bBp5oH7Y7eSLir5Sjw")
        
        Realm.Configuration.defaultConfiguration = configuration
        // Get on-disk location of the default Realm
        let realm = try! Realm()
        print("Realm is located at:", realm.configuration.fileURL!)
        //set noti delegate
        UNUserNotificationCenter.current().delegate = self
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }
}

