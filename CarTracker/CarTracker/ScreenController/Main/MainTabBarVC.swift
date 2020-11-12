//
//  MainTabBarVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/13/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class MainTabBarVC: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tabbarController = UITabBarController()
        let main1 = MainVC()
        main1.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let main1Nav = BaseNavigationController(rootViewController: main1)
        
        let main2 = Main2VC()
        main2.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let main2Nav = BaseNavigationController(rootViewController: main2)
        self.viewControllers = [main1Nav,main2Nav]
        
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
