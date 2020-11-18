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

    var folderName : String!
    var id : Int!
    var image : String!
    var name : String!
    var type : String!

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

