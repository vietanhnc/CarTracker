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
    @objc dynamic var year = ""
    
    @objc dynamic var isMoving = false
    @objc dynamic var image = ""
    
    @objc dynamic var lat = ""
    @objc dynamic var lng = ""
    @objc dynamic var seq:Int = 0
    @objc dynamic var time:Int = 0
    
    var isSelect:Bool = false
    @objc dynamic var status = ""
    
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
        result.isMoving = self.isMoving
        result.image = self.image
        result.lat = self.lat
        result.lng = self.lng
        result.seq = self.seq
        result.time = self.time
        result.isSelect = self.isSelect
        result.year = self.year
        result.status = self.status
        return result
    }
    
    override init() {
        super.init()
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        expiredGuaranteeDate = json["expiredGuaranteeDate"].stringValue
        imei = json["imei"].stringValue
        activeDate = json["activeDate"].stringValue
        deviceId = json["deviceId"].stringValue
        bks = json["bks"].stringValue
        phone = json["phone"].stringValue
        model = json["model"].stringValue
        brand = json["brand"].stringValue
        year = json["year"].stringValue
        
        isMoving = json["isMoving"].boolValue
        image = json["image"].stringValue
        
        lat = "0"
        lng = "0"
        seq = 0
        time = 0
        let location = json["location"].dictionary
        if let locationUW = location {
            lat = locationUW["lat"]?.stringValue ?? "0"
            lng = locationUW["lng"]?.stringValue ?? "0"
            seq = locationUW["seq"]?.intValue ?? 0
            time = locationUW["time"]?.intValue ?? 0
        }
    }
}
