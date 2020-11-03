//
//  TestCode.swift
//  CarTracker
//
//  Created by VietAnh on 10/17/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class AppConstant{
    public static var BASE_URL = "3d.vnest.vn"
    public static var BASE_HTTP_URL = "https://vnest.vn/car-management/"

    public static var SUBCRIBE_PORT :UInt16 = 1885
    public static var PUBLISH_PORT :UInt16 = 2885
    public static var SUBSCRIBE_TOPIC_BASE_URL = "/vnest/phone/subscribe/"
    public static var SUBSCRIBE_TOPIC_SALT = "vnest"
    
    public static func getSubTopic(_ phone:String)->String{
        let result = SUBSCRIBE_TOPIC_BASE_URL
        let md5part = MD5(string: (phone + SUBSCRIBE_TOPIC_SALT))
        return result + md5part
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
}
