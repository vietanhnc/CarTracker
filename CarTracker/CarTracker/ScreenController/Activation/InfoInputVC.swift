//
//  InfoInputVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/11/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
class InfoInputVC: BaseViewController {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
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
            }
        } catch{
        }
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        guard let phone = self.currentOTP?.desc else {return}
        guard let name = txtName.text else {return}
        guard let email = txtEmail.text else {return}
        service.updateInfo(name, email, phone, completion: { data in
            
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
