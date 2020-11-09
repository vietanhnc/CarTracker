//
//  SystemParameter.swift
//  CarTracker
//
//  Created by VietAnh on 11/9/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
class SystemParameter: Object {
    @objc dynamic var type = ""
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var ext1 = ""
}
