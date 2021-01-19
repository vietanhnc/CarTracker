//
//  AlertView.swift
//  CarTracker
//
//  Created by VietAnh on 11/8/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {
    /// The top most view controller
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else if self is UIAlertController {
            return nil
        } else {
            return self
        }
    }
}

class AlertView{
    static var currentOverlayTarget : UIView?
    
    static func show(){
        self.show("Có lỗi xảy ra!")
    }
    
    static func show(_ message: String?) {
        let msg = message ?? ""
//        let msg = (message ?? "").isEmpty ? "Có lỗi xảy ra!" : message;
        let alert = UIAlertController(title: "Thông báo", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))        
        UIApplication.topMostViewController?.present(alert, animated: true, completion: nil)
    }
    
//    static func show(_ message: String?,OKCompletion: (@escaping ()->())?) {
//        let msg = message ?? ""
////        let msg = (message ?? "").isEmpty ? "Có lỗi xảy ra!" : message;
//        let alert = UIAlertController(title: "Thông báo", message: msg, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        UIApplication.topMostViewController?.present(alert, animated: true, completion: nil)
//        
//        
//
//    }
    
    
}
