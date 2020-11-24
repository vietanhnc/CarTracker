//
//  UIViewExt.swift
//  CarTracker
//
//  Created by VietAnh on 11/14/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import Foundation
import UIKit
extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
//extension UITextField
//{
//    open override func draw(_ rect: CGRect) {
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.init(hexaRGB: "#9C9C9C")!.cgColor
//        self.layer.cornerRadius = 10.0
//    }
//}
