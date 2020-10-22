//
//  ViewController.swift
//  CarTracker
//
//  Created by VietAnh on 10/15/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, CocoaMQTTDelegate {
    var mqtt: CocoaMQTT?
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck")
        mqtt.subscribe("/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7")
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
        print("didSubscribeTopic")
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        performSegue(withIdentifier: "welcome_tabBar", sender: nil)
        
        initMQTT()
//        let mqtt = MQTTConnectionManager.shared()
//        mqtt.setDelegate(delegate: self)
//        mqtt.subscribe()
        
    }
    func initMQTT(){
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        print(clientID)
        mqtt = CocoaMQTT(clientID: clientID, host: "207.148.28.161", port: 1885)
        mqtt!.username = "va"
        mqtt!.password = "123"
//        mqtt.willMessage = CocoaMQTTWill(topic: "/vnest/phone/subscribe/ec420904bba9e463bcd4e89e37e7e0f7", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.allowUntrustCACertificate = true
        mqtt!.autoReconnect = true
        mqtt!.logLevel = .debug
        mqtt!.connect()
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let map = storyboard.instantiateViewController(withIdentifier: "mapScreen")
        //        if ((map as? UIViewController ) != nil) {
        //            map.modalPresentationStyle = .fullScreen
        //            self.present(map, animated: true, completion: nil)
        //        }
        
//        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabbar")
//        tabbar.modalPresentationStyle = .fullScreen
//        self.present(tabbar, animated: true, completion: nil)
        
    }
    
}

