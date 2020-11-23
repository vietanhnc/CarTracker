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
    
    @IBOutlet weak var brandCollectionView: CarBrandColView!
    let mainService :MainService = MainService()
    var carBrands: [Brand]? = nil
    var selectedCarBrand:Brand? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        mainService.fetchGetCarBrand { (error, data) in
            if error == nil{
                self.carBrands = data
//                print(self.brandCollectionView)
//                CarBrandColView.carBrands = self.carBrands
                self.brandCollectionView.reloadData()
            }
        }
        
        brandCollectionView.tag = 1
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
extension SelectBrandVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        if let carBrandsUW = self.carBrands {
            itemCount = carBrandsUW.count
        }
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! BrandCell
        let tag = collectionView.tag
        if tag == 1 {
            let carBrandsUW = carBrands!
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! BrandCell
            let item = carBrandsUW[indexPath.row]
            let url = URL(string: item.image)
            cell.brandImg?.kf.setImage(with: url)
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
            cell.layer.cornerRadius = 10.0
            cell.clipsToBounds = true
            if item.isSelect {
                cell.layer.borderColor = AppUtils.getAccentColor().cgColor
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemHeight, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = collectionView.tag
        if tag == 1 {
            guard let carBrandsUW = carBrands else{return}
            for (index, element) in carBrandsUW.enumerated() {
                if index == indexPath.row {
                    element.isSelect = true;
                    self.selectedCarBrand = element
                }else{
                    element.isSelect = false;
                }
            }
            self.carBrands = carBrandsUW;
            collectionView.reloadData()
        }
    }
}
