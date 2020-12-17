//
//  LocationMainVCMQTTDelegate.swift
//  CarTracker
//
//  Created by VietAnh on 12/12/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import CocoaMQTT
import UserNotifications

extension LocationMainVC:CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck")
        guard let subTopic = UserInfoDAO.getCurrentUserInfo()?.mqttSubTopic else { return }
        mqtt.subscribe(subTopic)
        //        if isSubscriber(mqtt) {
        //            mqtt.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
        //        }else{
        //
        //        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        //        0#Xe Inova [bks:29A00100] đang di chuyển#212333459606868,f92b1e8fa4d5fc14,21.0135815:105.8038809
        print("didReceiveMessage:\(String(describing: message.string))")
        guard let msgStr = message.string else {return}
        let lvl0Arr = msgStr.components(separatedBy: "#")
        //        212333459606868,f92b1e8fa4d5fc14,21.0135815:105.8038809
        if lvl0Arr.count < 3 { return }
        let isNoti = lvl0Arr[0]
        let notiMessage = lvl0Arr[1]
        let lvl02 = lvl0Arr[2]
        let lvl02Arr = lvl02.components(separatedBy: ",")
        if lvl02Arr.count < 3 { return }
        let imei = lvl02Arr[0]
        let deviceId = lvl02Arr[1]
        let lvl022 = lvl02Arr[2]
        //        21.0135815:105.8038809
        let lvl022Arr = lvl022.components(separatedBy: ":")
        if lvl022Arr.count < 2 { return }
        let lat =  lvl022Arr[0]
        let long =  lvl022Arr[1]
        //save to DB
        let param = CarDevice()
        param.imei = String.init(imei)
        param.deviceId = String.init(deviceId)
        param.lat = String.init(lat)
        param.lng = String.init(long)
        param.time = Int(Date().timeIntervalSince1970)
        CarDeviceDAO.updateCarDevice(param)
        service.reloadDataFromDB()
        self.carDeviceArrChanged()
        changeMapCurrentLocation()
        if "1" == isNoti {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "WEBVISION"
            content.body = notiMessage
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: "MQTTNoti", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { error in
                print(error)
            })
        }
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
