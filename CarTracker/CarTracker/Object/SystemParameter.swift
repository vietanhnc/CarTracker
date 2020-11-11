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
    
    init(_ type:String,_ code:String,_ name:String,_ desc:String,_ ext1:String) {
        self.type = type
        self.code = code
        self.name = name
        self.desc = desc
        self.ext1 = ext1
    }
    init(_ sysParam:SystemParameter?) {
        self.type = sysParam?.type ?? ""
        self.code = sysParam?.code ?? ""
        self.name = sysParam?.name ?? ""
        self.desc = sysParam?.desc ?? ""
        self.ext1 = sysParam?.ext1 ?? ""
    }
    
    override init() {
        
    }
}
