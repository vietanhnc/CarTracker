//
//  BaseError.swift
//  CarTracker
//
//  Created by VietAnh on 11/8/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation

class BaseError{
    var statusCode:Int!
    var code:Int!
    var errorCode:String!
    var description:String!
    
    init(_ statusCode:Int?,_ code:Int?,_ errorCode:String?,_ description:String?) {
        self.statusCode = statusCode ?? -1
        self.code = code ?? -1
        self.errorCode = errorCode ?? ""
        self.description = description ?? "Có lỗi xảy ra!"
    }
}
