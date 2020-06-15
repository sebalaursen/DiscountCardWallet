//
//  SignInViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /26/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import Locksmith

class SignInViewController: UIViewController {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func proceedBtn(_ sender: Any) {
        if loginTF.text != "", passwordTF.text != "" {
            if let pass = Locksmith.loadDataForUserAccount(userAccount: loginTF.text!) {
                if pass["Password"] as? String == passwordTF.text! {
                    Wallet.shared.owner = loginTF.text!
                    Wallet.shared.empty()
                    CoreDataStack().load()
                    
                    performSegue(withIdentifier: "finishedSignInSegue", sender: nil)
                } else {
                    alertPopUp(title: "Error", message: "Wrong password.")
                }
            } else {
                alertPopUp(title: "Error", message: "Wrong username.")
            }
        } else {
            alertPopUp(title: "Empty fields", message: "Please fill in all fields.")
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToSignUp", sender: nil)
    }
}
