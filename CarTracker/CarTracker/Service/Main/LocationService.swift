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
    
    func isIndexSelected(_ index:Int) -> Bool {
        let result = false
        if let dataSourceUW = self.dataSource, let selectedDeviceUW = self.selectedDevice {
            for (i,item) in dataSourceUW.enumerated() {
                if selectedDeviceUW.deviceId == item.deviceId  && index == i{
                    return true
                }
            }
        }
        return result
    }
    
    func getCurrentLocation(completion: @escaping (_ errorMsg:String?,_ carDevices:CarDevice?) -> Void) {
        guard let selectedDeviceUW = self.selectedDevice else {return}
        Request.shared().fetch(APIRouter.GetCurrLocation(selectedDeviceUW.imei, selectedDeviceUW.deviceId),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let position = dataUW.response["postion"]
                var carDeviceMuted = selectedDeviceUW.clone()
                carDeviceMuted.lat = position["lat"].stringValue
                carDeviceMuted.lng = position["lng"].stringValue
                carDeviceMuted.seq = position["seq"].intValue
                carDeviceMuted.time = position["time"].intValue
                CarDeviceDAO.updateCarDevice(carDeviceMuted)
                for (index,temp) in self.dataSource!.enumerated() {
                    if temp.deviceId == selectedDeviceUW.deviceId {
                        self.dataSource![index] = selectedDeviceUW
                    }
                }
                completion(nil,selectedDeviceUW)
            }else{
                completion("error",nil)
            }
        })
    }
    
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
    
    func getSelectedLocation()->(lat: Double, long: Double, title:String){
//        21.028511,_ long:Double = 105.804817
        let _lat = Double(self.selectedDevice?.lat ?? "21.028511" )
        let _long = Double(self.selectedDevice?.lng ?? "105.804817" )
        var _title = ""
        if self.selectedDevice != nil && self.selectedDevice!.time != 0 {
            _title = DateUtils.formatDateTime(self.selectedDevice!.time, "dd-MM-yyyy HH:mm:ss")
        }
        return (_lat!,_long!,_title)
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
//            selectedDevice = result![0]
            self.setSetlectedDevice(0)
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
