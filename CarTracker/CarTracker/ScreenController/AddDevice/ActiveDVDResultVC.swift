//
//  ActiveDVDResultVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/25/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class ActiveDVDResultVC: UIViewController {

    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnHome.layer.cornerRadius = AppConstant.CORNER_RADIUS
        // Do any additional setup after loading the view.
    }

    @IBAction func btnHomeTouch(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
