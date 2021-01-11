//
//  HistoryDetailVC.swift
//  CarTracker
//
//  Created by VietAnh on 12/14/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftDate
class HistoryDetailVC: BaseViewController {
    
    @IBOutlet var viewDeviceInfo: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var imgCarLogo: UIImageView!
    @IBOutlet var lblBKS: UILabel!
    @IBOutlet var lblCarBrand: UILabel!
    @IBOutlet var btnPlay: UIButton!
    
    var selectedDevice:CarDevice
    var locationHisArr:[LocationHistory]
    
    init(carDevice: CarDevice, locHisArr:[LocationHistory]) {
        self.selectedDevice = carDevice
        self.locationHisArr = locHisArr
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        selectedDevice = CarDevice()
        locationHisArr = [LocationHistory]()
        super.init(coder: aDecoder)
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = "Lịch sử di chuyển"
        viewDeviceInfo.layer.cornerRadius = AppConstant.CORNER_RADIUS
        viewDeviceInfo.makeShadow()
        
        mapView.layer.cornerRadius = AppConstant.CORNER_RADIUS
        mapView.makeShadow()
        
        lblBKS.text = selectedDevice.bks
        lblCarBrand.text = selectedDevice.model + " | " + selectedDevice.year
        
        let url = URL(string: selectedDevice.image)
        imgCarLogo?.kf.setImage(with: url)
        
        //setup mapView
        mapView.clear()
        
        let path = GMSMutablePath()
        for (index,locHis) in locationHisArr.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(locHis.lat, locHis.long)
            let date = Date(timeIntervalSince1970: Double(locHis.time))
            marker.title = date.toFormat("dd/MM/yyyy HH:mm",locale: Locales.vietnamese)
            marker.snippet = locHis.velo
            if index == 0 || index == locationHisArr.count-1 {
                marker.map = mapView
            }
            
            path.add(CLLocationCoordinate2D(latitude: locHis.lat, longitude: locHis.long))
            if index == locationHisArr.count-1 {
                //                mapView.selectedMarker = marker
                let camera = GMSCameraPosition.camera(withLatitude: locHis.lat, longitude: locHis.long, zoom: 15.0)
                mapView.animate(to: camera)
            }
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = UIColor.init(hexaRGB: "#694F74")!
        polyline.map = mapView
    }
    
    
    
    override func setupData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var runIndex = 0
    var markerMoving = GMSMarker()
    var isRuning = false
    func runFromLocToLoc(){
        if runIndex == self.locationHisArr.count - 1 {
            mapView.selectedMarker = nil
            isRuning = false
            return
        }
        
        let fromLoc = self.locationHisArr[runIndex]
        let toLoc = self.locationHisArr[runIndex+1]
        
        markerMoving.position = CLLocationCoordinate2DMake(fromLoc.lat, fromLoc.long)
        let date = Date(timeIntervalSince1970: Double(fromLoc.time))
        markerMoving.title = date.toFormat("dd/MM/yyyy HH:mm",locale: Locales.vietnamese)
        markerMoving.snippet = fromLoc.velo
        markerMoving.map = self.mapView
        mapView.selectedMarker = markerMoving
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setCompletionBlock({
            self.runIndex += 1
            self.runFromLocToLoc()
        })
        markerMoving.position = CLLocationCoordinate2DMake(toLoc.lat, toLoc.long)
        
        CATransaction.commit()
    }
    
    func startAnimation(){
        if self.locationHisArr.count > 1 {
            if self.isRuning {
                return
            }
            isRuning = true
            runIndex = 0
            
            markerMoving = GMSMarker()
            self.runFromLocToLoc()
        }
    }
    
    @IBAction func btnPlayTouch(_ sender: Any) {
        self.startAnimation()
    }
}
