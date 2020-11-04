//
//  Request.swift
//  CarTracker
//
//  Created by VietAnh on 11/3/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import Alamofire
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
    
    func post(_ apiRouter:APIRouter){
        print(apiRouter.getBody())
        AF.request(apiRouter).responseJSON{response in
//            debugPrint(response)
//            let json = String(data: response.data!, encoding: String.Encoding.utf8)
//            print(json)
        }
        //        print(parameters!)
        //        AF.request(buildURL(url), method: .post,  parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
        //                    debugPrint(response)
        //                    let json = String(data: response.data!, encoding: String.Encoding.utf8)
        //                    print(json)
        //        }
    }
}
