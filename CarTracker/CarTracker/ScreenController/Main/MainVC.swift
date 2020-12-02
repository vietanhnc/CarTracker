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
class MainVC: BaseViewController {
    
    @IBOutlet var view1: UIView!
    @IBOutlet var viewNodata: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet var carousel1: UICollectionView!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnActive: UIButton!
    
    let mainService :MainService = MainService()
    //    var carDeviceArr :[CarDevice]? = nil
//    var carDeviceArr: PublishSubject<[CarDevice]?> = PublishSubject<[CarDevice]?>()
    var dataSource:[CarDevice]? = nil
    private let disposeBag = DisposeBag()
    override func setupData() {
        mainService.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArrChanged(data)
            }
        })
    }
    
    override func setupUI() {
        
        carousel1.dataSource = self
        carousel1.delegate = self
        carousel1.register(UINib.init(nibName: "CarDeviceCell", bundle: nil), forCellWithReuseIdentifier: "CarDeviceCell")
//        carDeviceArr.asObservable().bind(to: self.carousel1.rx.items) { (collectionView, row, element ) in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarDeviceCell", for: IndexPath(row : row, section : 0))
//            //customize cell
//            return cell
//        }.disposed(by: disposeBag)
//        let paddingTop:CGFloat = self.view.frame.height*2/12
//        view1.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingTop)
//        ])
//        btnBuy.translatesAutoresizingMaskIntoConstraints = false
        
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
        btnActive.backgroundColor = UIColor.white
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
        self.dataSource = value
        self.carousel1.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //subcribe
//        carDeviceArr.asObservable().subscribe { event in
//            guard let value = event.element else{ return }
//            self.carDeviceArrChanged(value)
//        }.disposed(by: disposeBag)
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
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carDeviceUW = dataSource!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarDeviceCell", for: indexPath) as! CarDeviceCell
        let item = carDeviceUW[indexPath.row]
        cell.lblBKS.text = item.bks
        cell.lblIMEI.text = item.imei
        cell.lblExpire.text = item.expiredGuaranteeDate
        cell.layer.cornerRadius = AppConstant.CORNER_RADIUS
        let url = URL(string: item.image)
        cell.imgCarImage?.kf.setImage(with: url)
        cell.backgroundColor = UIColor.init(hexaRGB: "#F7F7F7")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height
        let itemWidth = collectionView.bounds.width - 40
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
//        print("index:\(currentIndex)")
        self.carousel1.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}
