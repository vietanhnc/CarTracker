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
    public static func updateCarDevice(_ device:CarDevice){
        do{
            let realm = try Realm()
            if let dbObject = realm.objects(CarDevice.self).filter("deviceId == '\(device.deviceId)' and imei == '\(device.imei)' ").first {
                try realm.write {
                    dbObject.lat = device.lat
                    dbObject.lng = device.lng
                    dbObject.seq = device.seq
                    dbObject.time = device.time
                    
                    dbObject.brand = device.brand
                    dbObject.model = device.model
                    dbObject.bks = device.bks
                    dbObject.phone = device.phone
                    dbObject.deviceId = device.deviceId
                    dbObject.imei = device.imei
                    dbObject.activeDate = device.activeDate
                    dbObject.expiredGuaranteeDate = device.expiredGuaranteeDate
                    dbObject.isMoving = device.isMoving
                    dbObject.image = device.image
                    dbObject.isSelect = device.isSelect
                    dbObject.year = device.year
                    dbObject.status = device.status
                }
            }
        } catch{
        }
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
    public static func getCarDevice(_ query:String)->[CarDevice]?{
        var result:[CarDevice]? = nil
        do{
            let realm = try Realm()
            if query != "" {
                let realmResults = realm.objects(CarDevice.self).filter(query)
                result = Array(realmResults)
            }else{
                let realmResults = realm.objects(CarDevice.self)
                result = Array(realmResults)
            }
            if result != nil && result!.count > 0 {
                
            }else{
                result = nil
            }
        } catch{
        }
        return result
    }
    
    
}
