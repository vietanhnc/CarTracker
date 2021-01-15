//
//  CarDeviceSettingCell.swift
//  CarTracker
//
//  Created by VietAnh on 1/14/21.
//  Copyright © 2021 MSB. All rights reserved.
//

import UIKit

class CarDeviceSettingCell: UITableViewCell {
    
    @IBOutlet var swiStatus: UISwitch!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
