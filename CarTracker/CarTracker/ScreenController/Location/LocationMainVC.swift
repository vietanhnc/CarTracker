//
//  Main2VCViewController.swift
//  CarTracker
//
//  Created by VietAnh on 11/13/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationMainVC: BaseViewController, GMSMapViewDelegate {
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var caroselVie: UIView!
    @IBOutlet var carousel: UICollectionView!
    @IBOutlet var notifyView: UIView!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var mapViewContainer: UIView!
    
    var mainMap:GMSMapView! = GMSMapView()
    var service:LocationService = LocationService()
    
    func getData()->[CarDevice]?{
        return service.dataSource
    }
    
    override func setupData() {
        service.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArrChanged()
                self.selectedCarChange(0)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myString = "Hãy trang bị ngay cho xế cưng đầu DVD WebVision để tận hưởng những tính năng giải trí đỉnh cao"
        let subString = "DVD WebVision"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 11)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:AppUtils.getSubtringIndex(myString, subString),length:subString.count))
        lblNoData.attributedText = myMutableString
        
        notifyView.layer.cornerRadius = AppConstant.CORNER_RADIUS
        notifyView.makeShadow()
        
        //carousel setup
        carousel.dataSource = self
        carousel.delegate = self
        carousel.register(UINib.init(nibName: "CarDeviceLocCell", bundle: nil), forCellWithReuseIdentifier: "CDLCell")
        //btnhisory
        btnHistory.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnHistory.layer.borderWidth = CGFloat(1)
        btnHistory.layer.borderColor = AppUtils.getSecondaryColor().cgColor
        let spacing:CGFloat = 10; // the amount of spacing to appear between image and title
        btnHistory.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing);
        btnHistory.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0);
        
        
        btnHistory.setTitleColor(AppUtils.getSecondaryColor(), for: .normal)
        btnHistory.makeShadow()
        
    }
    
    func showCollView(_ collViewShow:Bool){
        if collViewShow {
            carousel.isHidden = false
            viewNoData.isHidden = true
        }else{
            carousel.isHidden = true
            viewNoData.isHidden = false
        }
    }
    
    func selectedCarChange(_ index:Int){
        if service.isIndexSelected(index) {
            return
        }
        service.setSetlectedDevice(index)
        self.service.getCurrentLocation(completion: { error,data in
            if(error == nil){
                self.changeMapCurrentLocation()
            }
        })
    }
    
    func carDeviceArrChanged(){
        guard let carDeviceUW = getData() else{
            showCollView(false);return
        }
        if carDeviceUW.count == 0{
            showCollView(false)
        }else{
            showCollView(true)
        }
        self.carousel.reloadData()
    }
    
    func changeMapCurrentLocation() {
        let result = service.getSelectedLocation()
        setupMapview(result.lat, result.long,result.title)
    }
    
    func setupMapview(_ lat:Double = 21.028511,_ long:Double = 105.804817,_ title:String = ""){
//        let lat = 21.028511
//        let long = 105.804817
        let mapFrame = CGRect(x: 0, y: 0, width: mapViewContainer.layer.bounds.width, height: mapViewContainer.layer.bounds.height)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        let mainMap = GMSMapView.map(withFrame: mapFrame, camera: camera)
        //        mainMap.isMyLocationEnabled = true
        //        mapView.delegate = self
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.map = mainMap
        if !title.isEmpty{
            marker.title = title
        }
        mainMap.layer.cornerRadius = AppConstant.CORNER_RADIUS
        mapViewContainer.addSubview(mainMap)
        mapViewContainer.layer.cornerRadius = AppConstant.CORNER_RADIUS
        mapViewContainer.makeShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupMapview()
    }
    /*
     // MARK: - Navigation
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension LocationMainVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getData()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carDeviceUW = getData()!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CDLCell", for: indexPath) as! CarDeviceLocCell
        let item = carDeviceUW[indexPath.row]
        cell.lblBKS.text = item.bks
        //        let bound = cell.lblStatus.layer.bounds
        //        cell.lblStatus.layer.bounds = CGRect(x: bound.origin.x, y: bound.origin.y, width: bound.width+20, height: bound.height)
        //        cell.lblDistance.setMargins(margin: 10)
        cell.lblStatus.text = item.isMoving ? "Di chuyển" : "Đang dừng"
        cell.lblStatus.backgroundColor = AppUtils.getAccentColor()
        cell.lblStatus.layer.cornerRadius = AppConstant.CORNER_RADIUS
        cell.lblDistance.text = "100m"
        let url = URL(string: item.image)
        cell.imgIcon?.kf.setImage(with: url)
        cell.layer.cornerRadius = AppConstant.CORNER_RADIUS
        cell.backgroundColor = UIColor.init(hexaRGB: "#F0F0F0")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedIndex = indexPath.row
//        print(selectedIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
//        print("index:\(currentIndex)")
        self.carousel.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.selectedCarChange(currentIndex)
    }
    
}
