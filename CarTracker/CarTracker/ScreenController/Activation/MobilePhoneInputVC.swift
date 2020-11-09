//
//  MobilePhoneInputVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/1/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import SwiftyJSON
class MobilePhoneInputVC: BaseViewController {
    
    @IBOutlet var txtPhone: UITextField!
    
    let service :ActivationService = ActivationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtPhone.text = String(Date().millisecondsSince1970)
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        service.sendOTP(txtPhone.text!, completion: { data in
            let otpVC = OTPInputVC()
            self.navigationController?.pushViewController(otpVC, animated: true)
        })
    }
    
    func sendOTPCompletion(_ dataParam:JSON?,_ error:String){
        guard dataParam != nil else{
            super.showAlert("")
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
