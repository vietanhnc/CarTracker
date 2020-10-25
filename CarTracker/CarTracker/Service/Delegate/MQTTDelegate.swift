//
//  MQTTDelegate.swift
//  CarTracker
//
//  Created by VietAnh on 10/24/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTDelegate : CocoaMQTTDelegate{
    func  isSubscriber(_ mqtt: CocoaMQTT) -> Bool {
        if mqtt.port == AppConstant.SUBCRIBE_PORT {
            return true
        }else{
            return false
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck")
        if isSubscriber(mqtt) {
            mqtt.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
        }else{
            
        }
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("didSubscribeTopic:\(topics)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect")
    }
    
    
}
