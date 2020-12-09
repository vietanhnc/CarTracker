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
        
        self.navigationController?.pushViewController(ListAgentVC(), animated: true)
    }
    
    @objc func connected(sender: UIButton){
        self.navigationController?.pushViewController(ListAgentVC(), animated: true)
    }
    
    var oldContentOffsetX:CGFloat = 0
    private var indexOfCellBeforeDragging = 0
    

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
            print("cell.bounds.width",cell.bounds.width)
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
            cell.btnDetail.layer.borderColor = UIColor.init(hexaRGB: "#707070")?.cgColor
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
            
            cell.btnDetail.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)

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
//            self.carousel1.scrollToItem(at:  IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated:true)
//            guard let dataSourceUW = self.dataSource else {return}
//            if dataSourceUW[currentIndex].isSelect != true {
                self.carousel1.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                setDatasouce1Selected(currentIndex)
//            }
        }else{
            self.carousel2.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            setDatasouce2Selected(currentIndex)
        }
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let pageWidth = 345// The width your page should have (plus a possible margin)
//        let proportionalOffset = carousel1.contentOffset.x / CGFloat(pageWidth)
//        indexOfCellBeforeDragging = Int(round(proportionalOffset))
//
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // Stop scrolling
//        targetContentOffset.pointee = scrollView.contentOffset
//
//        // Calculate conditions
//        let pageWidth = 345// The width your page should have (plus a possible margin)
//        let collectionViewItemCount = 3// The number of items in this section
//        let proportionalOffset = carousel1.contentOffset.x / CGFloat(pageWidth)
//        let indexOfMajorCell = Int(round(proportionalOffset))
//        let swipeVelocityThreshold: CGFloat = 0.5
//        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewItemCount && velocity.x > swipeVelocityThreshold
//        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//
//        if didUseSwipeToSkipCell {
//            // Animate so that swipe is just continued
//            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//            let toValue = CGFloat(pageWidth) * CGFloat(snapToIndex)
//            UIView.animate(
//                withDuration: 0.3,
//                delay: 0,
//                usingSpringWithDamping: 1,
//                initialSpringVelocity: velocity.x,
//                options: .allowUserInteraction,
//                animations: {
//                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                    scrollView.layoutIfNeeded()
//                },
//                completion: nil
//            )
//        } else {
//            // Pop back (against velocity)
//            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//            carousel1.scrollToItem(at: indexPath, at: .left, animated: true)
//        }
//    }
    

    
    func setDatasouce1Selected(_ index:Int){
        guard let dataSourceUW = self.dataSource else {return}
        for (i,item) in dataSourceUW.enumerated() {
            if index == i {
                item.isSelect = true
            }else{
                item.isSelect = false
            }
        }
        self.dataSource = dataSourceUW
    }
    
    func setDatasouce2Selected(_ index:Int){
        guard let dataSourceUW = self.dvdList else {return}
        for (i,item) in dataSourceUW.enumerated() {
            if index == i {
                item.isSelect = true
            }else{
                item.isSelect = false
            }
        }
        self.dvdList = dataSourceUW
    }
}
