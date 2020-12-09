//
//  DVDInfo.swift
//  CarTracker
//
//  Created by VietAnh on 12/8/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class DVDInfo : Object{
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var price = ""
    @objc dynamic var priceSaleOff = ""
    @objc dynamic var image = ""
    var isSelect:Bool = false
    
    override init() {
        super.init()
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        desc = json["description"].stringValue
        price = json["price"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        priceSaleOff = json["priceSaleOff"].stringValue
    }
    
    func clone()->DVDInfo {
        let result = DVDInfo()
        result.desc = self.desc
        result.price = self.price
        result.priceSaleOff = self.priceSaleOff
        result.name = self.name
        result.image = self.image
        result.isSelect = self.isSelect
        return result
    }
}
