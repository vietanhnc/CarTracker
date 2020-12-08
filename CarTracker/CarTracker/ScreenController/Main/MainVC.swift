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
    @IBOutlet var carousel2: UICollectionView!
    
    let mainService :MainService = MainService()
    //    var carDeviceArr :[CarDevice]? = nil
    //    var carDeviceArr: PublishSubject<[CarDevice]?> = PublishSubject<[CarDevice]?>()
    var dataSource:[CarDevice]? = nil
    var dvdList:[DVDInfo]? = nil
    private let disposeBag = DisposeBag()
    override func setupData() {
        mainService.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArrChanged(data)
            }
        })
        mainService.fetchDVDList(completion: { error,data in
            if(error == nil){
                self.dvdList = data
                self.carousel2.reloadData()
            }
        })
    }
    
    override func setupUI() {
        
        carousel1.dataSource = self
        carousel1.delegate = self
        carousel1.register(UINib.init(nibName: "CarDeviceCell", bundle: nil), forCellWithReuseIdentifier: "CarDeviceCell")
        carousel1.tag = 1
        
        carousel2.dataSource = self
        carousel2.delegate = self
        carousel2.register(UINib.init(nibName: "DVDInfoCell", bundle: nil), forCellWithReuseIdentifier: "DVDInfoCell")
        carousel2.tag = 2
        
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
        let tag = collectionView.tag
        if tag == 1 {
            return dataSource?.count ?? 0
        }else{
            return dvdList?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = collectionView.tag
        if tag == 1 {
            let carDeviceUW = dataSource!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarDeviceCell", for: indexPath) as! CarDeviceCell
            let item = carDeviceUW[indexPath.row]
            cell.lblBKS.text = item.bks
            cell.lblIMEI.text = item.imei
            cell.lblExpire.text = item.expiredGuaranteeDate
            cell.layer.cornerRadius = AppConstant.CORNER_RADIUS
            let url = URL(string: item.image)
            cell.imgCarImage?.kf.setImage(with: url)
            cell.backgroundColor = UIColor.init(hexaRGB: "#E8E8E8")
            return cell
        }else{
            let dvdListUW = dvdList!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DVDInfoCell", for: indexPath) as! DVDInfoCell
            let item = dvdListUW[indexPath.row]
            cell.lblTitle.text = item.name
            cell.lblDesc.text = item.desc
            cell.lblPrice.text = item.price
            cell.btnDetail.setTitle("Đăng ký ngay", for: .normal)
            cell.btnDetail.layer.cornerRadius = AppConstant.CORNER_RADIUS
            cell.btnDetail.layer.borderWidth = 1
//            cell.btnDetail.layer.borderColor = UIColor.init(red: 112, green: 112, blue: 112, alpha: 1).cgColor
            cell.btnDetail.layer.borderColor = UIColor.black.cgColor
            let fromStr = "mainVC.carousel2.fromPrice".localized()
            let myString = fromStr+item.price
            let subString = item.price
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:AppUtils.getSubtringIndex(myString, subString),length:subString.count))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(location:AppUtils.getSubtringIndex(myString, subString),length:subString.count))
            cell.lblPrice.attributedText = myMutableString
            cell.layer.cornerRadius = AppConstant.CORNER_RADIUS
            let url = URL(string: item.image)
            cell.imgImage?.kf.setImage(with: url)
            
            cell.backgroundColor = UIColor.init(hexaRGB: "#FFFFFF")
            return cell
        }
        
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
        let tag = scrollView.tag
        if tag == 1 {
            self.carousel1.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}
