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
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupData() {}
    
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func setText(){
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
