//
//  DeviceSwitchDelegate.swift
//  CarTracker
//
//  Created by VietAnh on 1/19/21.
//  Copyright © 2021 MSB. All rights reserved.
//

import Foundation
protocol DeviceSwitchProtocol:class {
    func update(_ deviceID:String, _ imei:String,_ status:String)
}
