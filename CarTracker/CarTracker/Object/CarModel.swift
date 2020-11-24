//
//  CarModel.swift
//  CarTracker
//
//  Created by Viet Anh on 11/24/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CarModel : Object{

    @objc dynamic var brandId = 0
    @objc dynamic var image = ""
    @objc dynamic var name = ""
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
//        brandId = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
    }
    
}
