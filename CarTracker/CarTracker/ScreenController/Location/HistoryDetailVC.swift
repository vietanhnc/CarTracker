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
        for (index,locHis) in locationHisArr.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(locHis.lat, locHis.long)
            let date = Date(timeIntervalSince1970: Double(locHis.time))
            marker.title = date.toFormat("dd/MM/yyyy HH:mm",locale: Locales.vietnamese)
            marker.snippet = locHis.velo
            marker.map = mapView
            if index == locationHisArr.count-1 {
                mapView.selectedMarker = marker
                let camera = GMSCameraPosition.camera(withLatitude: locHis.lat, longitude: locHis.long, zoom: 15.0)
                mapView.animate(to: camera)
            }
        }
    }
    
    override func setupData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
