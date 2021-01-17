//
//  MobilePhoneInputVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/1/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import SwiftyJSON
import TweeTextField
class MobilePhoneInputVC: BaseViewController {
    
    @IBOutlet var txtPhone: TweeAttributedTextField!
    @IBOutlet var btnContinue: UIButton!
    
    let service :ActivationService = ActivationService()
    
    override func setupUI() {
        btnContinue.backgroundColor = AppUtils.getAccentColor()
        btnContinue.layer.cornerRadius = 20
    }
    
    @IBAction func txtPhoneChange(_ sender: Any) {
        if !self.validatePhone() {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let errorInfo = NSAttributedString(string: "Số điện thoại không đúng định dạng.",
                                               attributes: [.paragraphStyle: paragraph])
            txtPhone.showInfo(errorInfo, animated: true)
        }else{
            txtPhone.showInfo("", animated: true)
        }
    }
    
    func validatePhone()->Bool{
        var result = false
        if let text = txtPhone.text {
            if text == "" || text.count != 10 {
                
            }else{
                result = true
            }
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        txtPhone.text = String(Date().millisecondsSince1970)
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        if !self.validatePhone() {
            return
        }
        service.checkPhoneActive(txtPhone.text!, completion: { data in
            print(data)
            if data == "OK" {
                let pw = PasswordInputVC(phone: self.txtPhone.text!)
                self.navigationController?.pushViewController(pw, animated: false)
            }else{
                self.service.sendOTP(self.txtPhone.text!, completion: { data in
                    let otpVC = OTPInputVC()
                    self.navigationController?.pushViewController(otpVC, animated: false)
                })
            }
        })
        
    }
    
    func sendOTPCompletion(_ dataParam:JSON?,_ error:String){
        guard dataParam != nil else{
            AlertView.show()
            return
        }
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
