//
//  MQTTManager.swift
//  CarTracker
//
//  Created by VietAnh on 12/13/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import CocoaMQTT
class MQTTManager {
    private var mqttSubscriber: CocoaMQTT?
    private var isSetup = false
    
    private init(){
        
    }
    
    //singleton
    private static var sharedMQTTManager: MQTTManager = {
        let mqttManager = MQTTManager()
        mqttManager.config()
        //config
        return mqttManager
    }()
    
    class func shared() -> MQTTManager {
        return sharedMQTTManager
    }
    
    func config(){
        //config sub
//        delegate = MQTTDelegate()
        let subID = "MQTT-subscriber-" + String(ProcessInfo().processIdentifier)
        mqttSubscriber = CocoaMQTT(clientID: subID, host: AppConstant.BASE_URL, port: AppConstant.SUBCRIBE_PORT)
        mqttSubscriber!.username = "va_sub"
        mqttSubscriber!.password = "123"
        mqttSubscriber!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqttSubscriber!.keepAlive = 60
//        mqttSubscriber!.delegate = self.delegate
        mqttSubscriber!.allowUntrustCACertificate = true
        mqttSubscriber!.autoReconnect = true
        mqttSubscriber!.logLevel = .debug
        
    }
    
    func setDelegate(delegate: CocoaMQTTDelegate){
        mqttSubscriber?.delegate = delegate
    }
    
    func getMQTT() -> CocoaMQTT? {
        return self.mqttSubscriber
    }
    
    func connect(){
        mqttSubscriber!.connect()
//        mqttSubscriber!.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
    }
}
