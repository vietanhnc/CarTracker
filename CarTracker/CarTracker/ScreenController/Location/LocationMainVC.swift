//
//  Main2VCViewController.swift
//  CarTracker
//
//  Created by VietAnh on 11/13/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import GoogleMaps
import SPPermissions
import CoreLocation

class LocationMainVC: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var caroselVie: UIView!
    @IBOutlet var carousel: UICollectionView!
    @IBOutlet var notifyView: UIView!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var mapView: GMSMapView!
    
    private var locationManager:CLLocationManager = CLLocationManager()
    private var indexOfCellBeforeDragging = 0
    //    var mainMap:GMSMapView! = GMSMapView()
    var service:LocationService = LocationService()
    var deviceLocation:CLLocation? = nil
    
    override func setupData() {
        self.requestPermission()
        service.fetchCarDevice(completion: { error,data in
            if(error == nil){
                self.carDeviceArrChanged()
                self.selectedCarChange(0)
                self.mqttSetup()
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
    
    func mqttSetup(){
        let manager = MQTTManager.shared()
        manager.setDelegate(delegate: self)
        manager.connect()
    }
    
    func setupLocationmanager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission(){
        let isAllowed = SPPermission.isAllowed(SPPermissionType.locationWhenInUse)
        let isDenied = SPPermission.isDenied(SPPermissionType.locationWhenInUse)
        if isAllowed {
            self.setupLocationmanager()
        } else if isDenied {
            AlertView.show("Ứng dụng không được cấp quyền truy cập vị trí. Vui lòng thiết lập lại trong phần Cài đặt của điện thoại.")
        } else {
            SPPermission.request(SPPermissionType.locationWhenInUse) {
                self.setupLocationmanager()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            latLngLabel.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
            print(location.coordinate.latitude,location.coordinate.longitude)
            self.deviceLocation = location
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    
    func getData()->[CarDevice]?{
        return service.dataSource
    }
    
    @IBAction func btnHistory(_ sender: Any) {
        if let selected = service.selectedDevice {
            self.navigationController?.pushViewController(HistorySelectDateVC(carDevice: selected), animated: true)
        }
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
        service.takeALook(completion: {
        })
        changeMapCurrentLocation()
        //        self.service.getCurrentLocation(completion: { error,data in
        //            if(error == nil){
        //                self.changeMapCurrentLocation()
        //            }else{
        //                self.mapView.clear()
        //            }
        //        })
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
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        mapView.animate(to: camera)
        mapView.clear()
        if !title.isEmpty{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.map = mapView
            marker.title = title
            mapView.selectedMarker = marker
        }
        mapView.layer.cornerRadius = AppConstant.CORNER_RADIUS
        mapView.makeShadow()
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
    
    func getCellWidth() -> CGFloat{
        return self.carousel.layer.bounds.width - 40 + 10;
    }
    
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
        if item.isMoving {
            cell.lblStatus.text = "Di chuyển"
            cell.lblStatus.backgroundColor = UIColor.init(red: 60, green: 142, blue: 224, alpha: 1)
        }else{
            cell.lblStatus.text = "Đang dừng"
            cell.lblStatus.backgroundColor = AppUtils.getAccentColor()
        }
        
        if let loc1 = deviceLocation {
            let loc2 = CLLocation.init(latitude: CLLocationDegrees.init(item.lat) ?? 0, longitude: CLLocationDegrees.init(item.lng) ?? 0)
            let distance:CLLocationDistance = loc1.distance(from: loc2)
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "en_US")
            formatter.numberStyle = .decimal
            formatter.allowsFloats = false
            let distanceInt = Int(distance)
            let distanceFormated = formatter.string(from: NSNumber(value: distanceInt))
            cell.lblDistance.text = "\(distanceFormated ?? "0")m"
        }else{
            cell.lblDistance.text = "~"
        }
        
        cell.lblStatus.layer.cornerRadius = AppConstant.CORNER_RADIUS
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
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
//        //        print("index:\(currentIndex)")
//        //            self.carousel.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//        self.selectedCarChange(currentIndex)
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = self.getCellWidth()// The width your page should have (plus a possible margin)
        let proportionalOffset:CGFloat = carousel.contentOffset.x / CGFloat(pageWidth)
        indexOfCellBeforeDragging = Int(round(proportionalOffset))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrolling
        targetContentOffset.pointee = scrollView.contentOffset
        
        // Calculate conditions
        let pageWidth = self.getCellWidth()// The width your page should have (plus a possible margin)
        let collectionViewItemCount = self.getData()?.count ?? 0// The number of items in this section
        let proportionalOffset = carousel.contentOffset.x / CGFloat(pageWidth)
        let indexOfMajorCell = Int(round(proportionalOffset))
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewItemCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            // Animate so that swipe is just continued
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = CGFloat(pageWidth) * CGFloat(snapToIndex)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                },
                completion: nil
            )
            self.selectedCarChange(snapToIndex)
        } else {
            // Pop back (against velocity)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            carousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.selectedCarChange(indexPath.row)
        }
    }
    
}
