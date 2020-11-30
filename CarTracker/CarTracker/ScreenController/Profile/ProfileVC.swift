//
//  ProfileVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/29/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var btnLogout: UIButton!
    var profileModel:ProfileModel = ProfileModel()
    
    override func setupUI() {
        if let uiUW = profileModel.userInfo {
            lblName.text = uiUW.name
            lblPhone.text = uiUW.phone
        }
        lblName.textColor = AppUtils.getSecondaryColor()
        btnLogout.setTitle("Đăng xuất", for: .normal)
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = AppUtils.getSecondaryColor().cgColor
        btnLogout.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnLogout.setTitleColor(AppUtils.getSecondaryColor(), for: .normal)
    }
    
    override func setupData() {
        profileModel.getCurrentUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func btnLogoutTOuch(_ sender: Any) {
        profileModel.deleteUser()
//        let window:UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        let vc = WelcomeVC()
        let navi = BaseNavigationController(rootViewController: vc)
        navi.navigationBar.isTranslucent = false
//        window?.rootViewController = navi
//        window?.makeKeyAndVisible()
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
