//
//  CarDeviceDAO.swift
//  CarTracker
//
//  Created by Viet Anh on 11/26/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class CarDeviceDAO{
    public static func getCurrentUserInfo()->UserInfo?{
        var result:UserInfo? = nil
        do{
            let realm = try Realm()
            if let currentUI = realm.objects(UserInfo.self).first {
                result = currentUI
            }
        } catch{
        }
        return result
    }
    public static func insertCarDevice(_ device:CarDevice){
        do{
            let realm = try Realm()
            try realm.write { realm.add(device) }
        } catch{
        }
    }
    public static func deleteCarDevice(_ query:String){
        do{
            let realm = try Realm()
            var deletedObjects = realm.objects(CarDevice.self)
            if query != "" {
                deletedObjects = realm.objects(CarDevice.self).filter(query)
            }
            try! realm.write {
                realm.delete(deletedObjects)
            }
        } catch{
        }
    }
}
