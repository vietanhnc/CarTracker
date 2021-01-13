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
    
    func reloadDataFromDB(){
        var currentIndex = 0
//        var currentDevice:CarDevice? = nil
        
        if let dataSourceUW = self.dataSource, let selectedDeviceUW = self.selectedDevice {
            for (i,item) in dataSourceUW.enumerated() {
                if selectedDeviceUW.deviceId == item.deviceId && selectedDeviceUW.imei == item.imei {
                    currentIndex = i
//                    currentDevice = item
                }
            }
        }
        
        let newDataSource:[CarDevice]? = CarDeviceDAO.getCarDevice("")
        if let newDataSourceUW = newDataSource, newDataSourceUW.count - 1 > currentIndex {
            selectedDevice = newDataSourceUW[currentIndex]
        }else{
            selectedDevice = nil
        }
        dataSource = newDataSource
    }
    
    func isIndexSelected(_ index:Int) -> Bool {
        let result = false
        if let dataSourceUW = self.dataSource, let selectedDeviceUW = self.selectedDevice {
            for (i,item) in dataSourceUW.enumerated() {
                if selectedDeviceUW.deviceId == item.deviceId && selectedDeviceUW.imei == item.imei && index == i{
                    return true
                }
            }
        }
        return result
    }
    
    func getGetLocationHistory(_ startTime:String,_ endTime:String, completion: @escaping (_ errorMsg:String?,_ locationHistory:[LocationHistory]?) -> Void) {
        guard let selectedDeviceUW = self.selectedDevice else {return}
        Request.shared().fetch(APIRouter.GetLocationHistory(selectedDeviceUW.imei, selectedDeviceUW.deviceId,startTime,endTime),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let historyJSON = dataUW.response["data"]
                var history:[LocationHistory]? = nil
                for (_,subJson):(String, JSON) in historyJSON {
                    let splits = subJson.stringValue.components(separatedBy: ":")
                    let obj = LocationHistory()
                    obj.deviceId = selectedDeviceUW.deviceId
                    obj.imei = selectedDeviceUW.imei
//                    obj.sequence = Int(splits[0])!
                    obj.lat = Double(splits[0])!
                    obj.long = Double(splits[1])!
                    obj.time = Int(splits[2])!
                    obj.velo = splits[3]
                    if history == nil {
                        history = [LocationHistory]()
                    }
                    history!.append(obj)
                }
                completion(nil,history)
            }else{
                AlertView.show("Không tìm thấy thông tin!");
                completion("Không tìm thấy thông tin!",nil)
            }
        })
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
    
    func takeALook(completion: @escaping () -> Void) {
        guard let selectedDeviceUW = selectedDevice else {return}
        Request.shared().fetch(APIRouter.TakeALook(selectedDeviceUW.imei, selectedDeviceUW.deviceId),completion: {_ in
            
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
        for (_,subJson):(String, JSON) in dvds {
            if result == nil {
                result = [CarDevice]()
            }
            let device = CarDevice(fromJson: subJson)
            // lay trong db ra xem co chua
            let queryResult = CarDeviceDAO.getCarDevice("deviceId == '\(device.deviceId)' AND imei == '\(device.imei)'")
            if queryResult == nil {
                // chua co thi insert
                device.status = "ACTV"
                CarDeviceDAO.insertCarDevice(device)
            }else{
                // co roi thi cap nhat info thoi, giu nguyen trang thai
                var oldStatus = queryResult![0].status
                if oldStatus.isEmpty {
                    oldStatus = "ACTV"
                }
                device.status = oldStatus
                CarDeviceDAO.updateCarDevice(device)
            }
            result?.append(device.clone())
        }
        if result != nil {
            self.setSetlectedDevice(0)
        }
        return result
    }
    
    func saveCarDeviceBK(_ dvds:JSON) -> [CarDevice]? {
        var result:[CarDevice]? = nil
        CarDeviceDAO.deleteCarDevice("")
        for (_,subJson):(String, JSON) in dvds {
            if result == nil {
                result = [CarDevice]()
            }
            let device = CarDevice(fromJson: subJson)
            
            CarDeviceDAO.insertCarDevice(device)
            result?.append(device.clone())
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
                    currentOTP.mqttSubTopic = info["mqttSubTopic"].stringValue
                }
            }
        } catch{
        }
        return result
    }
    
}
