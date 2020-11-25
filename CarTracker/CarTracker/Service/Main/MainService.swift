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
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let info = dataUW.response["info"]
                let dvds = dataUW.response["dvds"]
                let ui = self.saveUserInfo(info)
                let carDevices = self.saveCarDevice(dvds)
                completion(nil,carDevices)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    
    func saveCarDevice(_ dvds:JSON) -> [CarDevice]? {
        var result = [CarDevice]()
        return result
    }
    
    func saveUserInfo(_ info:JSON)->UserInfo{
        var result = UserInfo()
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(UserInfo.self).first {
                result = currentOTP
                try realm.write {
                    currentOTP.activeDate = info["activeDate"].stringValue
                    currentOTP.name = info["name"].stringValue
                    currentOTP.phone = info["phone"].stringValue
                    currentOTP.email = info["email"].stringValue
                }
            }
        } catch{
        }
        return result
    }
    
    func fetchGetCarBrand(completion: @escaping (_ errorMsg:String?,_ brands:[Brand]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrand,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let brandJSON = dataUW.response["brands"]
                var result = [Brand]()
                for (_,subJson):(String, JSON) in brandJSON {
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
    func fetchGetCarBrandModel(_ brandId:Int,completion: @escaping (_ errorMsg:String?,_ brands:[CarModel]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrandModel(brandId),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let modelJSON = dataUW.response["models"]
                var result = [CarModel]()
                for (_,subJson):(String, JSON) in modelJSON {
                    let brand = CarModel(fromJson: subJson)
                    brand.brandId = dataUW.response["brandId"].intValue
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
