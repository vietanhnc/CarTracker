//
//  ProfileVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/29/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import RealmSwift
class ProfileVC: BaseViewController, UITableViewDataSource, UITableViewDelegate{//
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var tblCarDevice: UITableView!
    @IBOutlet var viewTableContainer: UIView!
    var profileModel:ProfileModel = ProfileModel()
    
    override func setupUI() {
        if let uiUW = profileModel.userInfo {
            lblName.text = uiUW.name
            lblPhone.text = uiUW.phone
        }
        lblName.textColor = AppUtils.getSecondaryColor()
        btnLogout.setTitle("Đăng xuất", for: .normal)
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = AppUtils.getSecondaryColor().cgColor
        btnLogout.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnLogout.setTitleColor(AppUtils.getSecondaryColor(), for: .normal)
        
        tblCarDevice.dataSource = self
        tblCarDevice.delegate = self
        tblCarDevice.register(UINib(nibName: "CarDeviceSettingCell", bundle: nil), forCellReuseIdentifier: "CarDeviceSettingCell")
        
//        viewTableContainer.layer.cornerRadius = AppConstant.CORNER_RADIUS
//        viewTableContainer.makeShadow()
    }
    
    override func setupData() {
        profileModel.getCurrentUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let rowHeight = 44
        var frame:CGRect = self.tblCarDevice.frame;
        frame.size.height = CGFloat(rowHeight * (profileModel.carDevices?.count ?? 0))
//        self.tblCarDevice.frame = frame;
//        tblCarDevice.frame.height = CGFloat(rowHeight * profileModel.carDevices?.count)
        // Do any additional setup after loading the view.
    }


    @IBAction func btnLogoutTOuch(_ sender: Any) {
        profileModel.deleteUser()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
//        let window:UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        let vc = WelcomeVC()
        let navi = BaseNavigationController(rootViewController: vc)
        navi.navigationBar.isTranslucent = false
//        window?.rootViewController = navi
//        window?.makeKeyAndVisible()
        UIApplication.shared.keyWindow?.rootViewController = navi
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        let tag = mySwitch.tag
        var cd = profileModel.carDevices![tag]
        if value {
            profileModel.updateDeviceStatus(cd.deviceId, cd.imei, "ACTV")
        }else{
            profileModel.updateDeviceStatus(cd.deviceId, cd.imei, "DLTD")
        }
        tblCarDevice.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.carDevices?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = profileModel.carDevices![indexPath.row]
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentCell") as! AgentCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarDeviceSettingCell", for: indexPath) as! CarDeviceSettingCell
        cell.lblName?.text = item.bks + " " + item.model
        cell.swiStatus?.isOn = item.status == "ACTV" ? true : false
        cell.addBottomBorderWithColor(color: UIColor.init(hexaRGB: "#F1F1F2")!, width: 1)
        cell.swiStatus?.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        cell.swiStatus?.tag = indexPath.row
//        if indexPath.row == 0 {
//            cell.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//        }
//        if indexPath.row == profileModel.carDevices!.count-1 {
//            cell.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
//        }
        return cell
    }
    
}
