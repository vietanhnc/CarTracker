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
    
    func getBrandNameText() -> NSMutableAttributedString {
        let appName = "WEBVISION"
        let appName2 = "WEB"
        var appNameAttr = NSMutableAttributedString()
        appNameAttr = NSMutableAttributedString(string: appName, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30, weight: .heavy)])
        appNameAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.getAccentColor(), range: NSRange(location:AppUtils.getSubtringIndex(appName, appName2),length:appName2.count))
        
        return appNameAttr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupData() {}
    
    func setupUI() {
        //set back button text to ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

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
    
    func push(_ toViewController:UIViewController) {
        self.navigationController?.pushViewController(toViewController, animated: false)
    }
    
}
