//
//  SystemParameterDAO.swift
//  CarTracker
//
//  Created by Viet Anh on 11/26/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class SystemParameterDAO{
    public static func getSysParam(_ query:String)->SystemParameter?{
        var result:SystemParameter? = nil
        do{
            let realm = try Realm()
            if let object = realm.objects(SystemParameter.self).filter(query).first {
                result = object
            }
        } catch{
        }
        return result
    }
}
