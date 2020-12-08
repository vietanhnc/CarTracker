//
//  DVDInfoCell.swift
//  CarTracker
//
//  Created by VietAnh on 12/8/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class DVDInfoCell: UICollectionViewCell {

    @IBOutlet var imgImage: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnDetailTouch(_ sender: Any) {
    }
}
