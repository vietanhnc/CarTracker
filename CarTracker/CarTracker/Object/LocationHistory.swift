//
//  LocationHistory.swift
//  CarTracker
//
//  Created by VietAnh on 12/6/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class LocationHistory : Object{

    @objc dynamic var lat:Double = 0
    @objc dynamic var long:Double = 0
    @objc dynamic var time:Int = 0
    @objc dynamic var sequence:Int = 0
    @objc dynamic var imei = ""
    @objc dynamic var deviceId = ""
    
    override init() {
        super.init()
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    func clone()->LocationHistory {
        let result = LocationHistory()
        result.lat = self.lat
        result.long = self.long
        result.sequence = self.sequence
        result.deviceId = self.deviceId
        result.imei = self.imei
        result.time = self.time
        return result
    }
}
