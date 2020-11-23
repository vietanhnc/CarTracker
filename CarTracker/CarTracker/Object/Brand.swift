//
//  Brand.swift
//  CarTracker
//
//  Created by Viet Anh on 11/18/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Brand : Object{

    @objc dynamic var folderName = ""
    @objc dynamic var id = 0
    @objc dynamic var image = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""
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
        folderName = json["folderName"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        type = json["type"].stringValue
    }
    
}
