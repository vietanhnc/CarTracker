//
//  SelectBrandVC.swift
//  CarTracker
//
//  Created by Viet Anh on 11/18/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class SelectBrandVC: BaseViewController {
    
    let mainService :MainService = MainService()
    var carBrands: [Brand]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        mainService.fetchGetCarBrand { (error, data) in
            if error != nil{
                self.carBrands = data
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
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
