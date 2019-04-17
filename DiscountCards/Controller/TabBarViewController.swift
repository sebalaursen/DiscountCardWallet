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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBtn()
    }
    
    func setupBtn() {
        addBtn.setImage(UIImage(named: "Add"), for: .normal)
        addBtn.frame = CGRect(x: self.view.bounds.width - (tabBar.frame.width / 1.5),
                              y: tabBar.frame.origin.y,
                              width: tabBar.frame.width / 3,
                              height: tabBar.frame.height - self.view.safeAreaInsets.bottom)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        self.view.addSubview(addBtn)
    }
    
    func anime() {
        UIView.animate(withDuration: 0.05, animations: {
            self.addBtn.layer.opacity = 0.5
        }) {(isFinished) in
            UIView.animate(withDuration: 0.05, animations: {
                self.addBtn.layer.opacity = 1
            })
        }
    }
    
    @objc func addBtnAction(sender: UIButton!) {
        anime()
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: scannerManager.requestCameraPermission()
        case .authorized:
            let navController = self.viewControllers![0] as! UINavigationController
            let vc: UIViewController = navController.viewControllers[0]
            scannerManager.showScanner(viewController: vc as! ViewController)
        case .restricted, .denied: scannerManager.alertCameraAccessNeeded(viewController: self)
        @unknown default:
            print("error")
        }
    }
    
}
