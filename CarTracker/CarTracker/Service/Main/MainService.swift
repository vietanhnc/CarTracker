//
//  MainService.swift
//  CarTracker
//
//  Created by VietAnh on 11/16/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
class MainService{
    let service :ActivationService = ActivationService()
    func fetchCarDevice(completion: @escaping (_ errorMsg:String?,_ carDevices:[CarDevice]?) -> Void) {
        Request.shared().fetch(APIRouter.GetInfo,completion: {data in
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
    
    func fetchGetCarBrand(completion: @escaping (_ errorMsg:String?,_ brands:[Brand]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrand,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let brandJSON = dataUW.response["brands"]
                var result = [Brand]()
                for (index,subJson):(String, JSON) in brandJSON {
                    let brand = Brand(fromJson: subJson)
                    result.append(brand)
                }
                completion(nil,result)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    func fetchGetCarBrandModel(_ brandId:String,completion: @escaping (_ errorMsg:String?,_ brands:[Brand]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrandModel(brandId),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let brandJSON = dataUW.response["models"]
                var result = [Brand]()
                for (index,subJson):(String, JSON) in brandJSON {
                    let brand = Brand(fromJson: subJson)
                    result.append(brand)
                }
                completion(nil,result)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
}
