//
//  CarDeviceLocCell.swift
//  CarTracker
//
//  Created by VietAnh on 11/28/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class CarDeviceLocCell: UICollectionViewCell {

    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblBKS: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var btnDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnDetailTouch(_ sender: Any) {
    }
}
