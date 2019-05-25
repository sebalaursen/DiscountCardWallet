//
//  TabBarViewController.swift
//  DCC
//
//  Created by Sebastian on /18/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarViewController:  UITabBarController, UITabBarControllerDelegate {
    
    let addBtn = UIButton(type: .custom)
    let scannerManager = ScannerManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        switch selectedIndex {
        case 0:
            break
        case 1:
            ((self.viewControllers![1] as? UINavigationController)?.viewControllers[0] as? ViewController)?.hideMapStar()
        default:
            break
        }
    }
    
}
