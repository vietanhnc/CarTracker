//
//  MQTTConnectionManager.swift
//  CarTracker
//
//  Created by VietAnh on 10/22/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTConnectionManager{
    private var mqttSubscriber: CocoaMQTT?
    private var mqttPublisher: CocoaMQTT?
    private var isSetup = false
    
    private init(){}
    
    //singleton
    private static var sharedMQTTManager: MQTTConnectionManager = {
        let mqttManager = MQTTConnectionManager()
        mqttManager.config()
        //config
        return mqttManager
    }()
    
    class func shared() -> MQTTConnectionManager {
        return sharedMQTTManager
    }
    
    func config(){
        //config sub
        let subID = "MQTT-subscriber-" + String(ProcessInfo().processIdentifier)
        mqttSubscriber = CocoaMQTT(clientID: subID, host: AppConstant.BASE_URL, port: AppConstant.SUBCRIBE_PORT)
        mqttSubscriber!.username = "va"
        mqttSubscriber!.password = "123"
        mqttSubscriber!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqttSubscriber!.keepAlive = 60
//        mqtt!.delegate = self
        mqttSubscriber!.allowUntrustCACertificate = true
        mqttSubscriber!.autoReconnect = true
        mqttSubscriber!.logLevel = .debug
//        mqttSubscriber!.connect()
//        mqttSubscriber!.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
        
        //config pub
        let pubID = "MQTT-publisher-" + String(ProcessInfo().processIdentifier)
        mqttPublisher = CocoaMQTT(clientID: pubID, host: AppConstant.BASE_URL, port: AppConstant.PUBLISH_PORT)
        mqttPublisher!.username = "va"
        mqttPublisher!.password = "123"
        mqttPublisher!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqttPublisher!.keepAlive = 60
//        mqtt!.delegate = self
        mqttPublisher!.allowUntrustCACertificate = true
        mqttPublisher!.autoReconnect = true
        mqttPublisher!.logLevel = .debug
    }
    
    func setDelegate(delegate: CocoaMQTTDelegate){
        mqttSubscriber?.delegate = delegate
        mqttPublisher?.delegate = delegate
    }
    
    func subscribe(){
        mqttSubscriber!.connect()
        mqttSubscriber!.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
    }
}
