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
    @IBOutlet var viewNodata: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet var carousel1: UICollectionView!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnActive: UIButton!
    
    let mainService :MainService = MainService()
    var carDeviceArr :[CarDevice]? = nil
    override func setupData() {
        mainService.fetchCarDevice(completion: { error,data,userInfo in
            if(error == nil){
                self.carDeviceArr = data
            }
        })
    }
//    Hãy trang bị ngay cho xế cưng đầu DVD WebVision để tận hưởng những tính năng giải trí đỉnh cao
    
    override func setupUI() {
        let paddingTop:CGFloat = self.view.frame.height*2/12
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingTop)
        ])
        btnBuy.translatesAutoresizingMaskIntoConstraints = false

        var myString = "Hãy trang bị ngay cho xế cưng đầu DVD WebVision để tận hưởng những tính năng giải trí đỉnh cao"
        var subString = "DVD WebVision"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:AppUtils.getSubtringIndex(myString, subString),length:subString.count))
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:10,length: 13))
        
        // set label Attribute
        lblNoData.attributedText = myMutableString

        
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
