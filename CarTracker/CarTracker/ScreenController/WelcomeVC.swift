//
//  WelcomeVC.swift
//  CarTracker
//
//  Created by VietAnh on 10/27/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class WelcomeVC: BaseViewController {
    let service :ActivationService = ActivationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, err) in
            print("granted: (\(granted)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        var nextView:UIViewController = MobilePhoneInputVC()
        do {
            let realm = try Realm()
            let currentUser = realm.objects(UserInfo.self).first
            if currentUser != nil {
                if currentUser?.password != nil {
//                    currentUser!.activeCode
                    service.login(currentUser!.phone, currentUser!.password, completion: { error in
                        if error == nil{
                            self.push(MainTabBarVC())
                        }else{
                            self.push(MobilePhoneInputVC())
                        }
                    })
                } else if currentUser?.name == nil || currentUser!.name.isEmpty {
                    self.push(InfoInputVC())
                }else{
                    self.push(MobilePhoneInputVC())
                }
            }else{
                self.push(MobilePhoneInputVC())
            }
        } catch{}
        
        
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
