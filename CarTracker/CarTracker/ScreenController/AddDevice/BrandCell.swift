//
//  BrandCell.swift
//  CarTracker
//
//  Created by Viet Anh on 11/20/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell {

    @IBOutlet weak var brandImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "brandCell")
    }

}
