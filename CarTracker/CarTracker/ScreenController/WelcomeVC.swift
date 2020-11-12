//
//  WelcomeVC.swift
//  CarTracker
//
//  Created by VietAnh on 10/27/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
class WelcomeVC: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextView:UIViewController = MobilePhoneInputVC()
//        mpvc.modalPresentationStyle = .fullScreen
//        mpvc.modalTransitionStyle = .crossDissolve
//        self.present(mpvc, animated: true, completion: nil)
        
//        let navi = BaseNavigationController(rootViewController: mpvc)
//        navi.navigationBar.isTranslucent = false
        do {
            let realm = try Realm()
            let currentUser = realm.objects(UserInfo.self).first
            if currentUser != nil {
                nextView = MainTabBarVC()
            }
        } catch{}
        
        self.navigationController?.pushViewController(nextView, animated: false)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
