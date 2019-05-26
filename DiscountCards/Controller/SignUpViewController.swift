//
//  SignUpViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /26/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import Locksmith

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! SignInViewController
        self.present(controller, animated: true, completion: { () -> Void in })
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if usernameTF.text != "", passwordTF.text != "", confirmPasswordTF.text != "" {
            if passwordTF.text == confirmPasswordTF.text {
                do {
                    try Locksmith.saveData(data: ["Password" : passwordTF.text!], forUserAccount: usernameTF.text!)
                    Wallet.shared.owner = usernameTF.text!
                    CoreDataStack().addUser(username: usernameTF.text!)
                    UserDefaults.standard.set(Float(5000), forKey: "Radius"+usernameTF.text!)
                    
                    performSegue(withIdentifier: "finishedSignUpSegue", sender: nil)
                } catch {
                    alertPopUp(title: "Error", message: "Username probably already exists or there was an error saving.")
                    print("Unable to save new user")
                }
            } else {
                alertPopUp(title: "Confirm Password", message: "Confirmation does not match password.")
            }
        } else {
            alertPopUp(title: "Empty fields", message: "Please fill in all fields.")
        }
    }
    
}
