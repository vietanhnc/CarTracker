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
        }
    }
    
    private var method: HTTPMethod{
        switch self {
        case .sendOTP,.active,.reSendOTP,.UpdateInfo:
            return .post
        }
    }
    
    private var body:Parameters{
        switch self {
        case .sendOTP(let phone),.reSendOTP(let phone):
            return ["phone":phone]
        case .active(let phone, let activeCode):
            return ["phone":phone,"activeCode":activeCode]
        case .UpdateInfo(let name,let email,let phone):
            return ["name":name,"email":email,"phone":phone]
        }
    }
    
    func getBody() -> Parameters {
        return body
    }
    
    func getURL() -> String {
        return AppConstant.BASE_HTTP_URL + path
    }
    
    public var header:[String:String]?{
        switch self {
        case .UpdateInfo:
            return ["accessToken":self.getAccessToken()]
        default:
            return nil
        }
    }
    
    private func getAccessToken()->String{
        do{
            let realm = try Realm()
            if let currentOTP = realm.objects(SystemParameter.self).filter("type == 'OTP_ACTIVE'").first {
                return currentOTP.ext1
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
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        urlRequest.httpBody = data
        return urlRequest
    }
}
