//
//  MainVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/12/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class MainVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var view1: UIView!
    @IBOutlet var viewNodata: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet var carousel1: UICollectionView!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnActive: UIButton!
    @IBOutlet var txtTest: UITextField!
    
    let mainService :MainService = MainService()
    //    var carDeviceArr :[CarDevice]? = nil
    var carDeviceArr: PublishSubject<[CarDevice]?> = PublishSubject<[CarDevice]?>()
    private let disposeBag = DisposeBag()
    override func setupData() {
        mainService.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArr.onNext(data)
            }
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
//        self.btnActive.becomeFirstResponder()
        return true;
    }
    
    override func setupUI() {
        txtTest.delegate = self
        let paddingTop:CGFloat = self.view.frame.height*2/12
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingTop)
        ])
        btnBuy.translatesAutoresizingMaskIntoConstraints = false
        
        let myString = "Hãy trang bị ngay cho xế cưng đầu DVD WebVision để tận hưởng những tính năng giải trí đỉnh cao"
        let subString = "DVD WebVision"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 11)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:AppUtils.getSubtringIndex(myString, subString),length:subString.count))
        
        // set label Attribute
        lblNoData.attributedText = myMutableString
        
        btnActive.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnActive.layer.borderWidth = 1
        btnActive.layer.borderColor = AppUtils.getSecondaryColor().cgColor
        
        btnBuy.layer.cornerRadius = AppConstant.CORNER_RADIUS
        self.view.layoutIfNeeded()
    }
    
    func showCollView(_ collViewShow:Bool){
        if collViewShow {
            carousel1.isHidden = false
            viewNodata.isHidden = true
        }else{
            carousel1.isHidden = true
            viewNodata.isHidden = false
        }
        
    }
    
    func carDeviceArrChanged(_ value:[CarDevice]?){
        guard let carDeviceUW = value else{
            showCollView(false);return
        }
        if carDeviceUW.count == 0{
            showCollView(false)
        }else{
            showCollView(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //subcribe
        carDeviceArr.asObservable().subscribe { event in
            guard let value = event.element else{ return }
            //            print(event)
            self.carDeviceArrChanged(value)
        }.disposed(by: disposeBag)
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
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
