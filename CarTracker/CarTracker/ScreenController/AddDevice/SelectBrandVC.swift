//
//  SelectBrandVC.swift
//  CarTracker
//
//  Created by Viet Anh on 11/18/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import Kingfisher


class SelectBrandVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var lblBKS: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var txtBKS: UITextField!
    @IBOutlet weak var brandCollectionView: CarBrandColView!
    @IBOutlet weak var carModelCollectionView: UICollectionView!
    @IBOutlet var txtYear: UITextField!
    let mainService :MainService = MainService()
    var carBrands: [Brand]? = nil
    var selectedCarBrand:Brand? = nil
    var carModel: [CarModel]? = nil
    var selectedCarModel: CarModel? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        mainService.fetchGetCarBrand { (error, data) in
            if error == nil{
                self.carBrands = data
                if let carBrandUW = self.carBrands {
                    self.setSelectBrand(carBrandUW[0])
                }
                
                self.brandCollectionView.reloadData()
            }
        }
        
        
        self.title = "selectCar.title".localized()
        
        lblBKS.text = "selectCar.text.bks".localized()
        lblBrand.text = "selectCar.text.brand".localized()
        lblModel.text = "selectCar.text.model".localized()
        lblYear.text = "selectCar.text.year".localized()
        
        txtBKS.delegate = self
        txtBKS.layer.masksToBounds = true
        txtBKS.layer.borderWidth = 1.0
        txtBKS.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
        txtBKS.layer.cornerRadius = AppConstant.CORNER_RADIUS

        txtYear.delegate = self
        txtYear.layer.masksToBounds = true
        txtYear.layer.borderWidth = 1.0
        txtYear.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
        txtYear.layer.cornerRadius = AppConstant.CORNER_RADIUS
        
        btnContinue.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnContinue.setTitle("continue".localized(), for: .normal)
        
        brandCollectionView.tag = 1
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.register(UINib.init(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "brandCell")
        
        carModelCollectionView.register(UINib.init(nibName: "BrandModel", bundle: nil), forCellWithReuseIdentifier: "brandModel")
        carModelCollectionView.tag = 2
        carModelCollectionView.delegate = self
        carModelCollectionView.dataSource = self
    }

    @IBAction func btnContinueTouch(_ sender: Any) {
        //validate
        if txtBKS.text == "" || txtYear.text == "" || selectedCarBrand == nil || selectedCarModel == nil {
            AlertView.show("error.showAlert.enterFullInfo".localized())
            return
        }
        mainService.activeDVD(selectedCarBrand!.name, selectedCarModel!.name, txtBKS.text!, txtYear.text!, completion: { error in
            if error == nil{
                self.navigationController?.pushViewController(ActiveDVDResultVC(), animated: true)
            }else{
                AlertView.show(error)
            }
        })
        
        
    }
    
    func setSelectBrand(_ sb:Brand){
        let selectedId = self.selectedCarBrand?.id ?? -1
        if sb.id == selectedId {
            return
        }
        for (_, element) in self.carBrands!.enumerated() {
            if element.id == sb.id {
                element.isSelect = true;
                self.selectedCarBrand = element
            }else{
                element.isSelect = false;
            }
        }
        self.getCarModel()
    }
    
    func getCarModel(){
        guard let selectedCarBrandUW = self.selectedCarBrand else {return}
        mainService.fetchGetCarBrandModel(selectedCarBrandUW.id, completion: { (error, data) in
            if error == nil{
                self.carModel = data
                self.carModelCollectionView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppUtils.getAccentColor().cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        textField.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;

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
        let tag = collectionView.tag
        if tag == 1 {
            if let carBrandsUW = self.carBrands {
                itemCount = carBrandsUW.count
            }
        }else{
            if let carModel = self.carModel {
                itemCount = carModel.count
            }
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag = collectionView.tag
        if tag == 1 {
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
            
            if item.isSelect {
                cell.layer.borderColor = AppUtils.getAccentColor().cgColor
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandModel", for: indexPath) as! BrandModel
            let carModelUW = carModel!
            let item = carModelUW[indexPath.row]
            cell.lblModelNam.text = item.name
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
            cell.layer.cornerRadius = AppConstant.CORNER_RADIUS
            cell.clipsToBounds = true
            cell.lblModelNam.textColor = UIColor.init(hexaRGB: "#9C9C9C")!
            if item.isSelect {
                cell.layer.borderColor = AppUtils.getAccentColor().cgColor
                cell.backgroundColor = AppUtils.getAccentColor()
                cell.lblModelNam.textColor = UIColor.white
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = collectionView.tag
        if tag == 1 {
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemHeight, height: itemHeight)
            
        }else{
            return CGSize(width: collectionView.bounds.width/2-10, height: 34)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let tag = collectionView.tag
        if tag == 1 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = collectionView.tag
        if tag == 1 {
            guard let carBrandsUW = carBrands else{return}
            self.setSelectBrand(carBrandsUW[indexPath.row])
            collectionView.reloadData()
            
        }else{
            guard let carModelUW = self.carModel else{return}
            for (index, element) in carModelUW.enumerated() {
                if index == indexPath.row {
                    element.isSelect = true;
                    self.selectedCarModel = element
                }else{
                    element.isSelect = false;
                }
            }
            self.carModel = carModelUW;
            collectionView.reloadData()
        }
    }
}
//extension SelectBrandVC: UITextFieldDelegate {
//
//}
