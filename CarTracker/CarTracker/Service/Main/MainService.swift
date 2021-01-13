//
//  MainService.swift
//  CarTracker
//
//  Created by VietAnh on 11/16/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
class MainService {
    let service :ActivationService = ActivationService()
    
    func fetchAgentList(completion: @escaping (_ errorMsg:String?,_ agentList:[Agent]?) -> Void) {
        Request.shared().fetch(APIRouter.getAgent,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let dataJSON = dataUW.response["datas"]
                var result = [Agent]()
                for (_,subJson):(String, JSON) in dataJSON {
                    let tempObj = Agent(fromJson: subJson)
                    result.append(tempObj.clone())
                }
                completion(nil,result)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    
    func fetchDVDList(completion: @escaping (_ errorMsg:String?,_ dvdList:[DVDInfo]?) -> Void) {
        Request.shared().fetch(APIRouter.GetDvdList,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let dvdsJSON = dataUW.response["datas"]
                var dvdInfoList = [DVDInfo]()
                for (_,subJson):(String, JSON) in dvdsJSON {
                    let dvd = DVDInfo(fromJson: subJson)
                    dvdInfoList.append(dvd.clone())
                }
                completion(nil,dvdInfoList)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    
    func fetchGetCarBrand(completion: @escaping (_ errorMsg:String?,_ brands:[Brand]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrand,completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let brandJSON = dataUW.response["brands"]
                var result = [Brand]()
                for (_,subJson):(String, JSON) in brandJSON {
                    let brand = Brand(fromJson: subJson)
                    result.append(brand)
                }
                completion(nil,result)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    func fetchGetCarBrandModel(_ brandId:Int,completion: @escaping (_ errorMsg:String?,_ brands:[CarModel]?) -> Void) {
        Request.shared().fetch(APIRouter.GetCarBrandModel(brandId),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                let modelJSON = dataUW.response["models"]
                var result = [CarModel]()
                for (_,subJson):(String, JSON) in modelJSON {
                    let brand = CarModel(fromJson: subJson)
                    brand.brandId = dataUW.response["brandId"].intValue
                    result.append(brand)
                }
                completion(nil,result)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg,nil);
            }
        })
    }
    
    func activeDVD(_ brand:String,_ model:String,_ bks:String,_ year:String,completion: @escaping (_ errorMsg:String?) -> Void) {
        //getPhone
        do {
        
        let ui = UserInfoDAO.getCurrentUserInfo()
        let phone = ui?.phone ?? ""
        let qrParam = SystemParameterDAO.getSysParam("type == 'QRSCAN'")
        let qrData = qrParam?.name ?? ""
        guard let dataFromString = qrData.data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        let qrDataJSON = try JSON(data: dataFromString)
        let imei = qrDataJSON["imei"].stringValue
        let deviceId = qrDataJSON["deviceId"].stringValue
        Request.shared().fetch(APIRouter.ActiveDVD(imei, deviceId, brand, model, bks, year, phone),completion: {data in
            guard let dataUW = data else{ AlertView.show(); return }
            if dataUW.isSuccess {
                completion(nil)
            }else{
                let errorMsg = data?.error.description ?? ""
                completion(errorMsg);
            }
        })
        } catch  {
            return
        }
    }
}
