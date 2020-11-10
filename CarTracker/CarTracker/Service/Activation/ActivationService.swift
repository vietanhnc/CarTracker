//
//  ActivationService.swift
//  CarTracker
//
//  Created by VietAnh on 11/4/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class ActivationService{
    func sendOTP(_ phone :String,completion: @escaping (_ errorMsg:String?) -> Void) {
        Request.shared().fetch(APIRouter.sendOTP(phone), completion: {data in
            guard data != nil else{
                AlertView.showError()
                return
            }
            if data!.error.statusCode == 400 {
                //PHONE_IS_USED call resend
                self.resendOTP(phone, completion: {data in
                    completion(nil)
                })
            }else{
                let otp = data!.response["activeCode"].stringValue
                self.saveOTP(phone, otp)
                completion(nil)
            }
        })
    }
    
    func saveOTP(_ phone:String,_ otp:String){
        let otpSP = SystemParameter()
        otpSP.type = "OTP_ACTIVE"
        otpSP.code = "CODE"
        otpSP.name = otp
        otpSP.desc = phone
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(SystemParameter.self).filter("type == 'OTP_ACTIVE'").first {
                try! realm.write { realm.delete(currentOTP) }
            }
            try realm.write { realm.add(otpSP) }
        } catch{
        }
    }
    
    func resendOTP(_ phone :String,completion: @escaping (_ data:BaseResponse?) -> Void) {
        Request.shared().fetch(APIRouter.reSendOTP(phone), completion: {data in
            guard data != nil else{
                AlertView.showError()
                return
            }
            if data!.isSuccess {
                let otp = data!.response["activeCode"].stringValue
                self.saveOTP(phone, otp)
                completion(data)
            }else{
                AlertView.show(data!.error.description)
                completion(data)
            }
        })
    }
    
    func active(_ phone:String,_ activeCode:String,completion: @escaping (_ data:String?) -> Void){
        Request.shared().fetch(APIRouter.active(phone, activeCode), completion: {data in
            guard data != nil else{ AlertView.showError(); return }
            if data!.isSuccess {
                //save accessToken
                let accessToken:String! = data?.response["accessToken"].stringValue
                do{
                    let realm = try Realm()
                    if let currentOTP = realm.objects(SystemParameter.self).filter("type == 'OTP_ACTIVE'").first {
                        try realm.write {
                            currentOTP.ext1 = accessToken
                        }
                    }
                } catch{
                }
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg);
            }
        })
    }
}
