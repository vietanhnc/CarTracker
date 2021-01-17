//
//  UserInfo.swift
//  CarTracker
//
//  Created by VietAnh on 11/11/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class UserInfo: Object {
    @objc dynamic var phone = ""
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var activeCode = ""
    @objc dynamic var accessToken = ""
    @objc dynamic var activeDate = ""
    @objc dynamic var mqttSubTopic = ""
    @objc dynamic var password = ""
    
    func clone()->UserInfo {
        let result = UserInfo()
        result.phone = self.phone
        result.name = self.name
        result.email = self.phone
        result.activeCode = self.activeCode
        result.accessToken = self.accessToken
        result.activeDate = self.activeDate
        result.mqttSubTopic = self.mqttSubTopic
        result.password = self.password
        return result
    }
    
}
