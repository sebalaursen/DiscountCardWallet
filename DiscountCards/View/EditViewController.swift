//
//  EditViewController.swift
//  DiscountCardWallet
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var cellIndex: Int!
    var pickedShop: String?
    var card: cardInfo?
    weak var delegate: cardDelegate?
    let shops = [ "", "CCC", "Watsons", "Рукавичка", "Other"]
    
    @IBOutlet weak var shopTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var barcodeImg: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setup() {
        setupShopPicker()
        setUpToolbar()
        
        titleTF.text = card?.title
        barcodeImg.image = fromString(string: card!.barcode)
        
        if (card?.logo != nil) {
            shopTF.text = card?.logo
        }
        else {
            shopTF.text = "Other"
        }
    }
    
    func setupShopPicker() {
        
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.backgroundColor = .lightGray
        
        shopTF.inputView = genderPicker
    }
    
    func setUpToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.darkGray
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        shopTF.inputAccessoryView = toolBar
    }
    
    func fromString(string : String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputCIImage = filter.outputImage {
                print(UIImage(ciImage: outputCIImage).size)
                return UIImage(ciImage: outputCIImage)
            }
        }
        return nil
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        if (shopTF.text != "" && titleTF.text != "") {
            card?.title = titleTF.text!
            card?.logo = shopTF.text!
            delegate?.editCard(card: card!, index: cellIndex)
            performSegue(withIdentifier: "doneEditSegue", sender: nil)
        }
        else if (shopTF.text != "" && titleTF.text != "") {
            card?.title = titleTF.text!
            card?.logo = nil
            delegate?.editCard(card: card!, index: cellIndex)
            performSegue(withIdentifier: "doneEditSegue", sender: nil)
        }
        else {
            let alert = UIAlertController(title: title, message: "Please enter all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        performSegue(withIdentifier: "doneEditSegue", sender: nil)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        delegate?.removeCard(index: cellIndex)
        performSegue(withIdentifier: "doneEditSegue", sender: nil)
    }
}

extension EditViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shops.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shops[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedShop = shops[row]
        shopTF.text = pickedShop
        
        if (pickedShop != "Other") {
            titleTF.text = pickedShop
        }
    }
}
