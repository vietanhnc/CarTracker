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
extension SelectBrandVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        let item = carBrandsUW[indexPath.row]
        let url = URL(string: item.image)
        cell.brandImg?.kf.setImage(with: url)
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemHeight = collectionView.bounds.height
//        let itemWidth = collectionView.bounds.width-20
        return CGSize(width: itemHeight, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        addToList.append(objectsArray[indexPath.row])
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.gray.cgColor
//        cell?.toggleSelected()
    }
}
