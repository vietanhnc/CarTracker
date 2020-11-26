//
//  UserInfoDAO.swift
//  CarTracker
//
//  Created by Viet Anh on 11/26/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class UserInfoDAO{
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
}
