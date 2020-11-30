//
//  CarDeviceCell.swift
//  CarTracker
//
//  Created by VietAnh on 11/26/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class CarDeviceLocationCell: UICollectionViewCell {

    @IBOutlet var imgCarImage: UIImageView!
    @IBOutlet var lblBKS: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var btnShowDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnShowDetailTouch(_ sender: Any) {
    }
    
}
