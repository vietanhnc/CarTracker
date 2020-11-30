//
//  OTPInputVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/9/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
class OTPInputVC: BaseViewController {
    
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var btnContinue: UIButton!
    let service :ActivationService = ActivationService()
    var currentOTP:UserInfo? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        btnContinue.backgroundColor = AppUtils.getAccentColor()
        btnContinue.layer.cornerRadius = 20
    }
    
    override func setupData(){
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(UserInfo.self).first {
                self.currentOTP = currentOTP.clone()
                txtOTP.text = currentOTP.activeCode
            }
        } catch{
        }
    }
    
    func validatePhone()->Bool{
        var result = false
        if let text = txtOTP.text {
            if text == "" || text.count != 5 {
                
            }else{
                result = true
            }
        }
        return result
    }
    
    @IBAction func btnConfirmTouch(_ sender: Any) {
        if !self.validatePhone() {
            return
        }
        guard let cOTPUnwraped = self.currentOTP else { return }
        service.active(cOTPUnwraped.phone, cOTPUnwraped.activeCode, completion: {data in
            if let errorMsg = data {
                AlertView.show(errorMsg)
            }else{
                let infoVC = InfoInputVC()
                self.navigationController?.pushViewController(infoVC, animated: false)
            }
        })
        
    }
    
    @IBAction func btnResendTouch(_ sender: Any) {
        guard let cOTPUnwraped = self.currentOTP else {
            return
        }
        service.resendOTP(cOTPUnwraped.phone, completion: { data in
            let otp = data!.response["activeCode"].stringValue
            self.txtOTP.text = otp
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
