//
//  BaseViewController.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 12/19/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Localize_Swift
class BaseViewController: UIViewController {
    var loading:UIActivityIndicatorView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {}
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
//        loading = UIActivityIndicatorView(style: .gray)
//        loading!.center = self.view.center
//        self.view.addSubview(loading!)
    }
    
    @objc func setText(){
    }
    
//    func showLoading(){
//        loading!.startAnimating()
//    }
//
//    func hideLoading(){
//        if let indicator = loading {
//            indicator.stopAnimating()
//        }
//    }
    
//    func showAlert(_ message:String?) -> Void {
//        let msg = (message ?? "").isEmpty ? "Có lỗi xảy ra!" : message!;
//        let alert = UIAlertController(title: "Thông báo", message: msg, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func fetch(_ apiRouter:APIRouter,completion: @escaping (_ data:BaseResponse?) -> Void) {
//        self.showLoading()
        Request.shared().fetch(apiRouter) { (data) in
//            self.hideLoading()
//            if let er = error {
//                completion(data,er)
//            }else{
//                self.showAlert(error?.description)
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
