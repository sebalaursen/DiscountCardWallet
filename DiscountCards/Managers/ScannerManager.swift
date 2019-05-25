//
//  File.swift
//  DCC
//
//  Created by Sebastian on /18/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import BarcodeScanner
import AVFoundation

protocol cardDelegate: class {
    func addCard(card: card)
    func removeCard(index: Int)
    func editCard(card: card, index: Int)
}

class ScannerManager {
    
    weak var delegate: cardDelegate?
    
    func showScanner(viewController: ViewController) {
        self.delegate = viewController
        
        let ScannerViewController = BarcodeScannerViewController()
        ScannerViewController.codeDelegate = self
        ScannerViewController.errorDelegate = self
        ScannerViewController.dismissalDelegate = self
        
        ScannerViewController.headerViewController.closeButton.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        ScannerViewController.messageViewController.messages.processingText = "Loading..."
        ScannerViewController.messageViewController.messages.scanningText = "Place the barcode within the window to scan."
        
        viewController.present(ScannerViewController, animated: true, completion: nil)
    }
    
    func showScannerr(viewController: FavoirtesViewController) {
        self.delegate = viewController
        
        let ScannerViewController = BarcodeScannerViewController()
        ScannerViewController.codeDelegate = self
        ScannerViewController.errorDelegate = self
        ScannerViewController.dismissalDelegate = self
        
        ScannerViewController.headerViewController.closeButton.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        ScannerViewController.messageViewController.messages.processingText = "Loading..."
        ScannerViewController.messageViewController.messages.scanningText = "Place the barcode within the window to scan."
        
        viewController.present(ScannerViewController, animated: true, completion: nil)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
        })
    }
    
    func alertCameraAccessNeeded(viewController: UIViewController) {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to scan barcodes.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension ScannerManager: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        if (!Wallet.shared.cards.contains(where: { $0.barcode == code})) { //meh, fix this maybe
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addController = storyboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
            
            addController.code = code
            addController.delegate = self.delegate
            controller.present(addController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(
                title: "Already exists",
                message: "This card already exists in your wallet.",
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                controller.reset(animated: true)
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
