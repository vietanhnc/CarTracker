//
//  SelectBrandVC.swift
//  CarTracker
//
//  Created by Viet Anh on 11/18/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import Kingfisher

class SelectBrandVC: BaseViewController {
    
    @IBOutlet weak var brandCollectionView: UICollectionView!
    let mainService :MainService = MainService()
    var carBrands: [Brand]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        mainService.fetchGetCarBrand { (error, data) in
            if error == nil{
                self.carBrands = data
                self.brandCollectionView.reloadData()
            }
        }
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.register(UINib.init(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "brandCell")
        

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
extension SelectBrandVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        carBrands.count
        var itemCount = 0
        if let carBrandsUW = self.carBrands {
            itemCount = carBrandsUW.count
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carBrandsUW = carBrands!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! BrandCell
//        let cell = BrandCell()
        let item = carBrandsUW[indexPath.row]
//        cell.nameLabel.text = item.name
//        cell.avatarImageView.image = UIImage(named: item.avatar)
        let url = URL(string: item.image)
        cell.brandImg?.kf.setImage(with: url)
        return cell
    }
}
