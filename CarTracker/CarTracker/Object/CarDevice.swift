//
//  RegistedCarInfo.swift
//  CarTracker
//
//  Created by VietAnh on 11/16/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CarDevice: Object {
    @objc dynamic var brand = ""
    @objc dynamic var model = ""
    @objc dynamic var bks = ""
    @objc dynamic var phone = ""
    @objc dynamic var deviceId = ""
    @objc dynamic var imei = ""
    @objc dynamic var activeDate = ""
    @objc dynamic var expiredGuaranteeDate = ""
    
    func clone()->CarDevice {
        let result = CarDevice()
        result.brand = self.brand
        result.model = self.model
        result.bks = self.bks
        result.phone = self.phone
        result.deviceId = self.deviceId
        result.imei = self.imei
        result.activeDate = self.activeDate
        result.expiredGuaranteeDate = self.expiredGuaranteeDate
        return result
    }
    
    override init() {
        super.init()
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
//        brandId = json["id"].intValue
        expiredGuaranteeDate = json["expiredGuaranteeDate"].stringValue
        imei = json["imei"].stringValue
        activeDate = json["activeDate"].stringValue
        deviceId = json["deviceId"].stringValue
        bks = json["bks"].stringValue
        phone = json["phone"].stringValue
        model = json["model"].stringValue
        brand = json["brand"].stringValue
    }
}
