//
//  ViewController.swift
//  CarTracker
//
//  Created by VietAnh on 10/15/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    var mqtt: CocoaMQTT?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initMQTT()
//        let mqtt = MQTTConnectionManager.shared();
//        let delegate = MQTTDelegate()
//        mqtt.setDelegate(delegate: delegate);
//        print(Unmanaged.passUnretained(delegate).toOpaque())
//        mqtt.subscribe()
    }
    func initMQTT(){
        
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

