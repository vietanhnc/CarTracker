//
//  WelcomeVC.swift
//  CarTracker
//
//  Created by VietAnh on 10/27/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let mpvc = MobilePhoneInputVC()
        mpvc.modalPresentationStyle = .fullScreen
        mpvc.modalTransitionStyle = .crossDissolve
        self.present(mpvc, animated: true, completion: nil)
        
//        self.show(mpvc, sender: self)
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
