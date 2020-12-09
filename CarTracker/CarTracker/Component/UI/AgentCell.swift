//
//  AgentCell.swift
//  CarTracker
//
//  Created by VietAnh on 12/10/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class AgentCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
