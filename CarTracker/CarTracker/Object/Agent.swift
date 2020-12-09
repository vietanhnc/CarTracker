//
//  Agent.swift
//  CarTracker
//
//  Created by VietAnh on 12/10/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Agent : Object{

    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var phone = ""
    
    override init() {
        super.init()
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    func clone()->Agent {
        let result = Agent()
        result.name = self.name
        result.address = self.address
        result.phone = self.phone
        return result
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
    }
}
