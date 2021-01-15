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
    
    func getCurrentUser(){
        userInfo = UserInfoDAO.getCurrentUserInfo()
    }
    
    func deleteUser(){
        UserInfoDAO.deleteUser()
    }
    
}
