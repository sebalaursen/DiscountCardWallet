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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        delegate = self
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        switch selectedIndex {
        case 0:
            ((self.viewControllers![0] as? UINavigationController)?.viewControllers[0] as? FavoirtesViewController)?.hideMapStar()
        case 1:
            var vc = ((self.viewControllers![1] as? UINavigationController)?.viewControllers[0] as? ViewController)?.hideMapStar()
        default:
            break
        }
    }
    
}
