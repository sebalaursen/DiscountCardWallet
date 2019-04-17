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
}

extension Notification.Name {
    static let addedCard = Notification.Name("addedCard")
    static let removedCard = Notification.Name("removedCard")
    static let editedCard = Notification.Name("editedCard")
    static let appLoaded = Notification.Name("appLoaded")
    static let alreadyExists = Notification.Name("alreadyExists")
}
