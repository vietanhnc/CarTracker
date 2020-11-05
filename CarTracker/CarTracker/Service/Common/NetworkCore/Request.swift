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
    
    func fetch(_ apiRouter:APIRouter,completion: @escaping (_ data:JSON?,_ error:String) -> Void){
        print(apiRouter.getBody())
        AF.request(apiRouter).responseJSON{response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(json,"")
                break
            case .failure:
                completion(nil,"Có lỗi xảy ra!")
                break
            }
        }
    }
}
