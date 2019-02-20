//
//  customCollectionCell.swift
//  DCC
//
//  Created by Sebastian on /17/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class cardCollectionCellImage: UICollectionViewCell {
    
    var index: Int = -1
    var createLogo: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var logoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    var barcodeView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    func setup() {
        addSubview(cellView)
        cellView.addSubview(logoView)
        cellView.addSubview(barcodeView)
        
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cellView.layer.cornerRadius = 16
        
        logoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        logoView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        logoView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        logoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -320).isActive = true
        
        barcodeView.backgroundColor = .lightGray
        barcodeView.topAnchor.constraint(equalTo: topAnchor, constant: 320).isActive = true
        barcodeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        barcodeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        barcodeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowOpacity = 1
        cellView.layer.shadowRadius = 2
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.masksToBounds = false
        
    }
    
}

class cardCollectionCellLabel: UICollectionViewCell {
    
    var index: Int = -1
    var createLogo: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    var labelView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        view.font = UIFont(name: "Helvetica", size: 40.0)
        
        return view
    }()
    
    var barcodeView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    func setup() {
        addSubview(cellView)
        cellView.addSubview(barcodeView)
        cellView.addSubview(labelView)
        
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cellView.layer.cornerRadius = 16
        
        barcodeView.backgroundColor = .lightGray
        barcodeView.topAnchor.constraint(equalTo: topAnchor, constant: 320).isActive = true
        barcodeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        barcodeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        barcodeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowOpacity = 1
        cellView.layer.shadowRadius = 2
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.masksToBounds = false
        
        labelView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        labelView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        labelView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        labelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -320).isActive = true
        
    }
    
}
