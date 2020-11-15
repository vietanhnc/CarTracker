//
//  MainVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/12/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
class MainVC: BaseViewController {
    
    @IBOutlet var view1: UIView!
    @IBOutlet var carousel1: UICollectionView!
    
    override func setupUI() {
        let paddingTop:CGFloat = self.view.frame.height*2/12
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingTop),
            view1.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: CGFloat(0.333)),
            view1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        //carousel1
        carousel1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carousel1.centerXAnchor.constraint(equalTo: carousel1.superview!.centerXAnchor),
            carousel1.topAnchor.constraint(equalTo: carousel1.superview!.topAnchor),
            carousel1.heightAnchor.constraint(equalTo: carousel1.superview!.heightAnchor, multiplier: CGFloat(0.75)),
            carousel1.leadingAnchor.constraint(equalTo: carousel1.superview!.leadingAnchor),
            carousel1.trailingAnchor.constraint(equalTo: carousel1.superview!.trailingAnchor),
        ])
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
