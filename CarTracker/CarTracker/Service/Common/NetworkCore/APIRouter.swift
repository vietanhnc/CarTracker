//
//  ActivationAPIRouter.swift
//  CarTracker
//
//  Created by VietAnh on 11/4/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
enum APIRouter: URLRequestConvertible{
    
    case sendOTP(_ phone: String)
    case reSendOTP(_ phone: String)
    case active(_ phone: String,_ activeCode: String)
    case UpdateInfo(_ name: String,_ email: String,_ phone: String)
    case login(_ UserName:String,_ Password:String)
    case GetInfo
    case GetCarBrand
    case GetCarBrandModel(_ brandId:Int)
    case ActiveDVD(_ imei:String,_ deviceId:String,_ brand:String,_ model:String,_ bks:String,_ year:String,_ phone:String)
    case GetCurrLocation(_ imei:String,_ deviceId:String)
    case GetLocationHistory(_ imei:String,_ deviceId:String,_ startTime:String,_ endTime:String)
    
    private var path: String {
        switch self {
        case .sendOTP:
            return "GetActiveCode"
        case .active:
            return "active"
        case .reSendOTP:
            return "ResendCode"
        case .UpdateInfo:
            return "UpdateInfo"
        case .login:
            return "login"
        case .GetInfo:
            return "GetInfo"
        case .GetCarBrand:
            return "GetCarBrand"
        case .GetCarBrandModel:
            return "GetCarModel"
        case .ActiveDVD:
            return "ActiveDVD"
        case .GetCurrLocation:
            return "GetCurrLocation"
        case .GetLocationHistory:
            return "GetLocationHistory"
        }
    }
    
    private var method: HTTPMethod{
        switch self {
        case .sendOTP,.active,.reSendOTP,.UpdateInfo,.login,.ActiveDVD,.GetLocationHistory:
            return .post
        default:
            return .get
        }
        
    }
    
    private var body:Parameters?{
        switch self {
        case .sendOTP(let phone),.reSendOTP(let phone):
            return ["phone":phone]
        case .active(let phone, let activeCode):
            return ["phone":phone,"activeCode":activeCode]
        case .UpdateInfo(let name,let email,let phone):
            return ["name":name,"email":email,"phone":phone]
        case .login(let UserName,let Password):
            return ["UserName":UserName,"Password":Password]
        case .ActiveDVD(let imei,let deviceId,let brand,let model,let bks,let year,let phone):
            return ["imei":imei,"deviceId":deviceId,"brand":brand,"model":model,"bks":bks,"year":year,"phone":phone]
        case .GetLocationHistory(let imei,let deviceId,let startTime,let endTime):
            return ["imei":imei,"deviceId":deviceId,"startTime":startTime,"endTime":endTime]
        default:
            return nil
        }
    }
    
    func getBody() -> Parameters? {
        return body
    }
    
    private var parameter:Parameters?{
        switch self{
        case .GetCarBrandModel(let brandId):
            return ["brandId":brandId]
        case .GetCurrLocation(let imei,let deviceId):
            return ["imei":imei,"deviceId":deviceId]
            
        default:
            return nil
        }
    }
    
    func getURL() -> String {
        switch self{
        case .GetCarBrandModel:
            return AppConstant.BASE_HTTP_URL + path
        default:
            return AppConstant.BASE_HTTP_URL + path
        }
    }
    
    public var header:[String:String]?{
        switch self {
        case .UpdateInfo,.login,.GetInfo,.GetCarBrand,.ActiveDVD,.GetCurrLocation,.GetLocationHistory:
            return ["accesstoken":self.getAccessToken()]
        default:
            return nil
        }
    }
    
    private func getAccessToken()->String{
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(UserInfo.self).first {
                return currentOTP.accessToken
            }
        } catch{
        }
        return ""
    }
    
    func asURLRequest() throws -> URLRequest {
//        let strURL = AppConstant.BASE_HTTP_URL + path
        let url = try self.getURL().asURL();
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
//        urlRequest = try URLEncoding.default.encode(urlRequest, with: param)
        if body != nil {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.httpBody = data
        }
        if parameter != nil {
//            let parameters: Parameters = ["foo": "bar"]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameter)
        }
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        return urlRequest
    }
}
