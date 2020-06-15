//
//  SettingsViewController.swift
//  DCC
//
//  Created by Sebastian on /18/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var radiusTF: UITextField!
    @IBOutlet weak var radiusSlider: UISlider!
    var currentRadius: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setup()
    }
    
    func setup() {
        radiusSlider.maximumValue = 10000.0
        radiusSlider.value = Settings.radius
        radiusTF.text = String(format: "%.0f", radiusSlider.value)
    }
    
    @IBAction func radiusSliderChanged(_ sender: Any) {
        radiusTF.text = String(format: "%.0f", radiusSlider.value)
        UserDefaults.standard.set(radiusSlider.value, forKey: "Radius"+Wallet.shared.owner)
    }
    
    @IBAction func radiusTFChanged(_ sender: Any) {
        if Float(radiusTF.text!)! > 10000.0 {
            radiusTF.text = String(format: "%.0f", 10000.0)
            radiusSlider.value = 10000.0
        } else {
            radiusSlider.value = Float(radiusTF.text!)!
        }
        Settings.radius = Float(radiusTF.text!)!
        UserDefaults.standard.set(Float(radiusTF.text!)!, forKey: "Radius"+Wallet.shared.owner)
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        CoreDataStack().saveContext()
        performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
}

class Settings {
    
    
    static var radius: Float =  UserDefaults.standard.float(forKey: "Radius"+Wallet.shared.owner)
    
}
