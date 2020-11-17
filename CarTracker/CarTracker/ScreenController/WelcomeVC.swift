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
    let service :ActivationService = ActivationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nextView:UIViewController = MobilePhoneInputVC()
        do {
            let realm = try Realm()
            let currentUser = realm.objects(UserInfo.self).first
            if currentUser != nil {
                if currentUser?.phone == nil || currentUser!.phone.isEmpty {
                    self.push(MobilePhoneInputVC())
                }else if currentUser?.activeCode == nil || currentUser!.activeCode.isEmpty{
                    self.push(OTPInputVC())
                }else if currentUser?.name == nil || currentUser!.name.isEmpty{
                    self.push(InfoInputVC())
                }else{
                    //login
                    service.login(currentUser!.phone, currentUser!.activeCode, completion: { error in
                        if error == nil{
                            self.push(MainTabBarVC())
                        }
                    })
                }
            }else{
                self.push(MobilePhoneInputVC())
            }
        } catch{}
        
        
        
    }
    
    func push(_ toViewController:UIViewController) {
        self.navigationController?.pushViewController(toViewController, animated: false)
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
