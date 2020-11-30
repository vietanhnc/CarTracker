//
//  MainTabBarVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/13/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import Localize_Swift

class MainTabBarVC: BaseTabBarController {
    
    func setupUI() {
        let main1 = MainVC()
        let main1Nav = BaseNavigationController(rootViewController: main1)
        let main1Icon = UIImage(named: "cole3")
        main1Nav.tabBarItem = UITabBarItem(title: "service".localized(),image: main1Icon,selectedImage: nil)
        
        let main2 = LocationMainVC()
        let main2Nav = BaseNavigationController(rootViewController: main2)
        main2Nav.tabBarItem = UITabBarItem(title: "carLocation".localized(),image: UIImage(named: "location"),selectedImage: nil)
        
        let main3 = ProfileVC()
        let main3Nav = BaseNavigationController(rootViewController: main3)
        main3Nav.tabBarItem = UITabBarItem(title: "account".localized(),image: UIImage(named: "user"),selectedImage: nil)
        
        self.tabBar.tintColor = AppUtils.getAccentColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)], for: .normal)


        self.viewControllers = [main1Nav,main2Nav,main3Nav]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        print(Localize.availableLanguages())
        
//        let tabbarController = UITabBarController()

        
//        tabbarController.viewControllers = [homeNavi, messagesNavi, friendsNavi, profileNavi]

        // Do any additional setup after loading the view.
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
