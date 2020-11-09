//
//  BaseResponse.swift
//  CarTracker
//
//  Created by VietAnh on 11/8/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import SwiftyJSON
class BaseResponse {
    var response:JSON
    var error:BaseError!
    var isSuccess:Bool!
    init(_ response:JSON?,_ error:BaseError?,_ isSuccess:Bool) {
        self.response = response ?? JSON("")
        self.error = error ?? BaseError(nil,nil,nil,nil)
        self.isSuccess = isSuccess
    }
}
