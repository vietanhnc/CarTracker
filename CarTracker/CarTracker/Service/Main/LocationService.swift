//
//  LocationService.swift
//  CarTracker
//
//  Created by VietAnh on 11/28/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class LocationService{
    
    var dataSource:[CarDevice]? = nil
    var selectedDevice:CarDevice? = nil
    func fetchCarDevice(completion: @escaping (_ errorMsg:String?,_ carDevices:[CarDevice]?) -> Void) {
        Request.shared().fetch(APIRouter.GetInfo,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let info = dataUW.response["info"]
                let dvds = dataUW.response["dvds"]
                self.saveUserInfo(info)
                let carDevices = self.saveCarDevice(dvds)
                self.dataSource = carDevices
                completion(nil,self.dataSource)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    
    func setSetlectedDevice(_ index:Int) {
        if let dataSourceUW = self.dataSource {
            if dataSourceUW.count > index {
                selectedDevice = dataSourceUW[index]
            }
        }
    }
    
    func saveCarDevice(_ dvds:JSON) -> [CarDevice]? {
        var result:[CarDevice]? = nil
        CarDeviceDAO.deleteCarDevice("")
        for (_,subJson):(String, JSON) in dvds {
            if result == nil {
                result = [CarDevice]()
            }
            let device = CarDevice(fromJson: subJson)
            result?.append(device)
            CarDeviceDAO.insertCarDevice(device)
        }
        if result != nil {
            selectedDevice = result![0]
        }
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
    
}
