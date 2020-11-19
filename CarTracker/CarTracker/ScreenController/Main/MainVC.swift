//
//  MainVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/12/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
class MainVC: BaseViewController {
    
    @IBOutlet var view1: UIView!
    @IBOutlet var carousel1: UICollectionView!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnActive: UIButton!
    
    let mainService :MainService = MainService()
    var carDeviceArr :[CarDevice]? = nil
    override func setupData() {
        mainService.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArr = data
            }
        })
    }
    
    override func setupUI() {
        let paddingTop:CGFloat = self.view.frame.height*2/12
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingTop)
        ])
        btnBuy.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnActiveTouch(_ sender: Any) {
        let nextView = ScanDeviceVC()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    
    @IBAction func btnBuyTouch(_ sender: Any) {
    }
    
}
