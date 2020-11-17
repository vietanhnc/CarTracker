//
//  MainService.swift
//  CarTracker
//
//  Created by VietAnh on 11/16/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift

class MainService{
    let service :ActivationService = ActivationService()
    func fetchCarDevice(completion: @escaping (_ errorMsg:String?,_ carDevices:[CarDevice]?) -> Void) {
        Request.shared().fetch(APIRouter.GetInfo(""),completion: {data in
            completion(nil,nil)
        })
        
//        Request.shared().fetch(APIRouter.sendOTP(phone), completion: {data in
//            guard data != nil else{
//                AlertView.show()
//                return
//            }
//            if data!.error.statusCode == 400 {
//                //PHONE_IS_USED call resend
//            }else{
//                let otp = data!.response["activeCode"].stringValue
//                completion(nil)
//            }
//        })
    }
}
