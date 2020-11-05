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
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        
        super.fetch(APIRouter.sendOTP(txtPhone.text!)) { (data, error) in
            self.sendOTPCompletion(data, error)
        }
    }
    
    func sendOTPCompletion(_ dataParam:JSON?,_ error:String){
        guard let data = dataParam else{
            super.showAlert("")
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
