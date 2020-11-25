//
//  AppUtils.swift
//  CarTracker
//
//  Created by VietAnh on 11/5/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class AppUtils{
    
    public static func getAccentColor()->UIColor{
//        #D62450
        return UIColor(red: CGFloat(0xD6) / 255.0, green: CGFloat(0x24) / 255.0, blue: CGFloat(0x50) / 255.0, alpha: 1);
    }
    
    public static func MD5(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
    
    public static func getSubTopic(_ phone:String)->String{
        let result = AppConstant.SUBSCRIBE_TOPIC_BASE_URL
        let md5part = MD5(string: (phone + AppConstant.SUBSCRIBE_TOPIC_SALT))
        return result + md5part
    }
    
    public static func getSubtringIndex(_ string:String,_ subString:String)->Int{
        let str = string
        if let range: Range<String.Index> = str.range(of: subString) {
            let index: Int = str.distance(from: str.startIndex, to: range.lowerBound)
            print(index)
            return index
        }
        else {
            return -1
        }
    }
}

