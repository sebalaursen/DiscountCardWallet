//
//  Extensions.swift
//  DiscountCards
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertPopUp(title: String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.view.tintColor = .gray
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let addedCard = Notification.Name("addedCard")
    static let addedFavCard = Notification.Name("addedFavCard")
    static let removedCard = Notification.Name("removedCard")
    static let removedFavCard = Notification.Name("removedFavCard")
    static let editedCard = Notification.Name("editedCard")
    static let appLoaded = Notification.Name("appLoaded")
    static let alreadyExists = Notification.Name("alreadyExists")
}
