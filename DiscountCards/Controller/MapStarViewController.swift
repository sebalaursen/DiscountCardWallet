//
//  MapStarViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /25/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class MapStarViewController: UIViewController {
    
    weak var parVC: UIViewController!
    
    var favBtn: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Favorite", for: .normal)
        view.addTarget(self, action: #selector(favAction), for: .touchUpInside)
        view.backgroundColor = .lightGray
        return view
    }()
    var mapBtn: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Find on map", for: .normal)
        view.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        view.backgroundColor = .lightGray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.view.addSubview(favBtn)
        self.view.addSubview(mapBtn)
        
        favBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        favBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        favBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        mapBtn.topAnchor.constraint(equalTo: favBtn.topAnchor, constant: 50).isActive = true
        mapBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        mapBtn.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        mapBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func favAction() {
        print("fav")
    }
    
    @objc func mapAction() {
        print("map")
    }
}
