//
//  PasswordInputVC.swift
//  CarTracker
//
//  Created by VietAnh on 1/16/21.
//  Copyright © 2021 MSB. All rights reserved.
//

import UIKit
import TweeTextField
class PasswordInputVC: BaseViewController {

    @IBOutlet var lblInfo: UILabel!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var txtPassword: TweeAttributedTextField!
    @IBOutlet var btnContinue: UIButton!
    let service :ActivationService = ActivationService()
    var phone:String  = ""
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func txtPasswordChanged(_ sender: Any) {
        if txtPassword.text!.isEmpty {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let errorInfo = NSAttributedString(string: "Vui lòng nhập mật khẩu.",
                                               attributes: [.paragraphStyle: paragraph])
            txtPassword.showInfo(errorInfo, animated: true)
        }else{
            txtPassword.showInfo("", animated: true)
        }
    }
    
    
    override func setupUI() {
        btnContinue.backgroundColor = AppUtils.getAccentColor()
        btnContinue.layer.cornerRadius = 20
        lblBrandName.attributedText = self.getBrandNameText()
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        guard let pwd = txtPassword.text else {return}
        if pwd.isEmpty {
            return
        }
        service.login(phone, txtPassword.text!, completion: { error in
            if error == nil {
                self.push(MainTabBarVC())
            }else{
                self.push(MobilePhoneInputVC())
            }
        })
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
