//
//  ProfileModel.swift
//  CarTracker
//
//  Created by VietAnh on 11/29/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
class ProfileModel {
    
    var userInfo:UserInfo? = nil
    var carDevices:[CarDevice]? = nil
    
    init() {
        carDevices = CarDeviceDAO.getCarDevice("")
    }
    
    func getCarDevices(){
        carDevices = CarDeviceDAO.getCarDevice("")
    }
    
    func getCurrentUser(){
        userInfo = UserInfoDAO.getCurrentUserInfo()
    }
    
    func deleteUser(){
        UserInfoDAO.deleteUser()
    }
//    ,completion: @escaping (_ device:CarDevice?) -> Void
    func updateDeviceStatus(_ deviceID:String, _ imei:String,_ status:String){
        let queryResult = CarDeviceDAO.getCarDevice("deviceId == '\(deviceID)' AND imei == '\(imei)'")
        if queryResult == nil {
        }else{
            var cd = queryResult![0].clone()
            cd.status = status
            CarDeviceDAO.updateCarDevice(cd)
            carDevices = CarDeviceDAO.getCarDevice("")
            //delegate
            delegate?.update(deviceID, imei, status)
            
        }
    }
    weak var delegate: DeviceSwitchProtocol?

    init(delegate: DeviceSwitchProtocol) {
        self.delegate = delegate
    }
}
