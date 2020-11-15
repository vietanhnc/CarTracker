//
//  RegistedCarInfo.swift
//  CarTracker
//
//  Created by VietAnh on 11/16/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class CarDevice: Object {
    @objc dynamic var carImageURL = ""
    @objc dynamic var carName = ""
    @objc dynamic var carNumber = ""
    @objc dynamic var deviceImageURL = ""
    @objc dynamic var deviceName = ""
    @objc dynamic var deviceIMEI = ""
    @objc dynamic var deviceDateActive = ""
    @objc dynamic var deviceDateExpire = ""
    
    func clone()->CarDevice {
        let result = CarDevice()
        result.carImageURL = self.carImageURL
        result.carName = self.carName
        result.carNumber = self.carNumber
        result.deviceImageURL = self.deviceImageURL
        result.deviceName = self.deviceName
        result.deviceIMEI = self.deviceIMEI
        result.deviceDateActive = self.deviceDateActive
        result.deviceDateExpire = self.deviceDateExpire
        return result
    }
    
}
