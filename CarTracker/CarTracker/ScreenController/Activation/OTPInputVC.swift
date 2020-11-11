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
    let service :ActivationService = ActivationService()
    var currentOTP:SystemParameter? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setupData(){
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(SystemParameter.self).filter("type == 'OTP_ACTIVE'").first {
                self.currentOTP = SystemParameter(currentOTP)
                txtOTP.text = currentOTP.name
            }
        } catch{
        }
    }
    
    @IBAction func btnConfirmTouch(_ sender: Any) {
        guard let cOTPUnwraped = self.currentOTP else { return }
        service.active(cOTPUnwraped.desc, cOTPUnwraped.name, completion: {data in
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
        service.resendOTP(cOTPUnwraped.desc, completion: { data in
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
