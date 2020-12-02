//
//  DateUtils.swift
//  CarTracker
//
//  Created by VietAnh on 12/3/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
class DateUtils {
    
    public static func formatDateTime(_ timestamp:Int,_ pattern:String)->String{
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = pattern //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    public static func formatDate(_ date:Date,_ pattern:String = "dd/MM/yyyy")-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }
    
}
