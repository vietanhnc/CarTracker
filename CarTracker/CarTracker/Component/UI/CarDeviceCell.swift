//
//  CarDeviceCell.swift
//  CarTracker
//
//  Created by VietAnh on 11/26/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class CarDeviceCell: UICollectionViewCell {

    @IBOutlet var imgCarImage: UIImageView!
    @IBOutlet var lblBKS: UILabel!
    @IBOutlet var lblIMEI: UILabel!
    @IBOutlet var lblExpire: UILabel!
    @IBOutlet var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnContinueTouch(_ sender: Any) {
    }
    
}
