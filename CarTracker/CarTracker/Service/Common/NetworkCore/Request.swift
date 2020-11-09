//
//  Request.swift
//  CarTracker
//
//  Created by VietAnh on 11/3/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner
class Request {
    
    //singleton
    private static var sharedRequest: Request = {
        let httpRequest = Request()
        //config
        return httpRequest
    }()
    
    class func shared() -> Request {
        return sharedRequest
    }
    
    private func buildURL(_ url :String)->String{
        let result = AppConstant.BASE_HTTP_URL + url;
        return result
    }
    
    func fetch(_ apiRouter:APIRouter,completion: @escaping (_ response:BaseResponse?) -> Void){
        print("REQUEST_URL:\(apiRouter.getURL())")
        print("REQUEST_BODY:\(apiRouter.getBody())")
        LoadingView.show()
        AF.request(apiRouter).responseJSON{response in
            LoadingView.hide()
            let httpStatusCode = response.response?.statusCode ?? -1
            print("RESPONSE_HTTP_STATUS:\(httpStatusCode)")
            
            switch response.result{
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                let statusCode:Int! = Int(json["statusCode"].string ?? "-1")
                let code:Int! = Int(json["code"].string ?? "-1")
                let error = BaseError(statusCode, code , json["errorCode"].string,json["description"].string)
                var baseResp:BaseResponse? = nil
                if statusCode>=200,statusCode<300 {
                    baseResp = BaseResponse(json, error,true)
                }else{
                    baseResp = BaseResponse(json, error,false)
                }
                completion(baseResp)
                break
            case .failure:
//                let error = BaseError(nil, nil, nil, "Có lỗi xảy ra!")
                let baseReps = BaseResponse(nil,nil,false)
                completion(baseReps)
                break
            }
        }
    }
}
