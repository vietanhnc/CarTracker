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
            guard data != nil else{ AlertView.show(); completion(""); return }
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
    
    func checkPhoneActive(_ phone :String,completion: @escaping (_ errorMsg:String?) -> Void) {
        Request.shared().fetch(APIRouter.checkPhoneActive(phone), completion: {data in
            guard data != nil else{ AlertView.show(); completion(""); return }
            if data!.error.statusCode == 400 {
                completion("PHONE_IS_NOT_ACTIVATED")
            }else{
                completion("OK")
            }
        })
    }
    
    func saveOTP(_ phone:String,_ otp:String){
        let currentUser = UserInfo()
        currentUser.phone = phone
        currentUser.activeCode = otp
        do{
            let realm = try Realm()
            if let ui = realm.objects(UserInfo.self).first {
                try! realm.write { realm.delete(ui) }
            }
            try realm.write { realm.add(currentUser) }
        } catch{
        }
//        let otpSP = SystemParameter()
//        otpSP.type = "OTP_ACTIVE"
//        otpSP.code = "CODE"
//        otpSP.name = otp
//        otpSP.desc = phone
//        do{
//            let realm = try Realm()
//            if let currentOTP = realm.objects(SystemParameter.self).filter("type == 'OTP_ACTIVE'").first {
//                try! realm.write { realm.delete(currentOTP) }
//            }
//            try realm.write { realm.add(otpSP) }
//        } catch{
//        }
    }
    
    func resendOTP(_ phone :String,completion: @escaping (_ data:BaseResponse?) -> Void) {
        Request.shared().fetch(APIRouter.reSendOTP(phone), completion: {data in
            guard data != nil else{ AlertView.show(); completion(nil); return }
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
            guard data != nil else{ AlertView.show(); completion(""); return }
            if data!.isSuccess {
                //save accessToken
                let accessToken:String! = data?.response["accessToken"].stringValue
                do{
                    let realm = try Realm()
                    if let currentOTP = realm.objects(UserInfo.self).first {
                        try realm.write {
                            currentOTP.activeCode = activeCode
                            currentOTP.accessToken = accessToken
                        }
                    }
                    completion(nil)
                } catch{
                }
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg);
            }
        })
    }
    
    func updateInfo(_ name:String,_ email:String,_ phone:String,completion: @escaping (_ data:String?) -> Void) {
        Request.shared().fetch(APIRouter.UpdateInfo(name, email, phone), completion: { data in
            guard data != nil else{ AlertView.show(); completion(""); return }
            if data!.isSuccess {
                //save UserInfo
                do{
                    let realm = try Realm()
//                    guard let currentOTP = realm.objects(UserInfo.self).first
//                          else {
//                        AlertView.show(); completion(""); return
//                    }
                    let currentUser = realm.objects(UserInfo.self).first
                    guard let currentUserUW = currentUser else {
                        AlertView.show(); completion(""); return
                    }
                    try realm.write {
//                        if currentUser != nil {
//                            //delete
//                            realm.delete(currentUser!)
//                        }
//                        currentUser = UserInfo()
//                        currentUser!.phone = currentOTP.desc
//                        currentUser!.activeCode = currentOTP.name
//                        currentUser!.accessToken = currentOTP.ext1
                        currentUserUW.name = name
                        currentUserUW.email = email
//                        realm.add(currentUser!)
                    }
                    completion(nil)
                } catch{
                }
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg);
            }
        })
    }
    
    func login(_ phone:String,_ password:String,completion: @escaping (_ data:String?) -> Void){
        Request.shared().fetch(APIRouter.login(phone, password), completion: {data in
            guard data != nil else{ AlertView.show(); completion(""); return }
            if data!.isSuccess {
                //save accessToken
                let accessToken:String! = data?.response["accessToken"].stringValue
                do{
                    let realm = try Realm()
                    let currentUser = realm.objects(UserInfo.self).first
                    if currentUser == nil {
                        let newUser = UserInfo()
                        newUser.phone = phone
                        newUser.password = password
                        newUser.accessToken = accessToken
                        try realm.write { realm.add(newUser) }
                    }else{
                        guard let currentUserUW = currentUser else{ completion(""); return }
                        try realm.write {
                            currentUserUW.accessToken = accessToken
                            currentUserUW.password = password
                        }
                    }
                    
                    completion(nil)
                } catch{
                    AlertView.show();completion(""); return
                }
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg);
            }
        })
    }
}
