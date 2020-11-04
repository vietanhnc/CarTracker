//
//  ActivationService.swift
//  CarTracker
//
//  Created by VietAnh on 11/4/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation

class ActivationService{
    func sendOTP(_ phone :String) {
        Request.shared().post(APIRouter.sendOTP(phone))
    }
}
