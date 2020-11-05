//
//  BaseViewController.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 12/19/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseViewController: UIViewController {
    var loading:UIActivityIndicatorView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupData() {}
    
    func setupUI() {
        loading = UIActivityIndicatorView(style: .gray)
        loading!.center = self.view.center
        self.view.addSubview(loading!)
    }
    
    func showLoading(){
        loading!.startAnimating()
    }
    
    func hideLoading(){
        if let indicator = loading {
            indicator.stopAnimating()
        }
    }
    
    func showAlert(_ message:String?) -> Void {
        let msg = (message ?? "").isEmpty ? "Có lỗi xảy ra!" : message!;
        let alert = UIAlertController(title: "Thông báo", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetch(_ apiRouter:APIRouter,completion: @escaping (_ data:JSON?,_ error:String) -> Void) {
        self.showLoading()
        Request.shared().fetch(apiRouter) { (data, error) in
            self.hideLoading()
            if error.isEmpty {
                completion(data,error)
            }else{
                self.showAlert(error)
            }
        }
    }
}
