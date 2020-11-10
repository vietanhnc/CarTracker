//
//  ActivationAPIRouter.swift
//  CarTracker
//
//  Created by VietAnh on 11/4/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible{
    
    case sendOTP(_ phone: String)
    case reSendOTP(_ phone: String)
    case active(_ phone: String,_ activeCode: String)
    
    
    private var path: String {
        switch self {
        case .sendOTP:
            return "GetActiveCode"
        case .active:
            return "active"
        case .reSendOTP:
            return "ResendCode"
        }
    }
    
    private var method: HTTPMethod{
        switch self {
        case .sendOTP,.active,.reSendOTP:
            return .post
        }
    }
    
    private var body:Parameters{
        switch self {
        case .sendOTP(let phone),.reSendOTP(let phone):
            return ["phone":phone]
        case .active(let phone, let activeCode):
            return ["phone":phone,"activeCode":activeCode]
        }
    }
    
    func getBody() -> Parameters {
        return body
    }
    
    func getURL() -> String {
        return AppConstant.BASE_HTTP_URL + path
    }
    
    func asURLRequest() throws -> URLRequest {
//        let strURL = AppConstant.BASE_HTTP_URL + path
        let url = try self.getURL().asURL();
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
//        urlRequest.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
//        urlRequest = try URLEncoding.default.encode(urlRequest, with: param)
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        urlRequest.httpBody = data
        return urlRequest
    }
}
