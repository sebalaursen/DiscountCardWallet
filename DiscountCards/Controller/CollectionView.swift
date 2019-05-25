//
//  CollectionView.swift
//  DiscountCards
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//


import UIKit
import ScaledVisibleCellsCollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        //collectionView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.view.addSubview(collectionView)
        
        collectionView.setScaledDesginParam(scaledPattern: .HorizontalCenter, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.7)
        
        collectionView.register(cardCollectionCellImage.self, forCellWithReuseIdentifier: cellIdentifier1)
        collectionView.register(cardCollectionCellLabel.self, forCellWithReuseIdentifier: cellIdentifier2)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    
    func collectionViewAdd() {
        collectionView.insertItems(at: [[0, Wallet.shared.cards.count - 1]])
        collectionView.scaledVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (isFiltering()) {
            return filteredCards.count
        }
        return Wallet.shared.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (isFiltering() && filteredCards[indexPath.row].logo != nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! cardCollectionCellImage
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//filteredCards[indexPath.row].backgroundColor
            cell.logoView.image = UIImage(named: Wallet.shared.cards[indexPath.row].logo!)
            cell.barcodeView.image = fromString(string: filteredCards[indexPath.row].barcode)
            cell.linkToWallet = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (isFiltering() && filteredCards[indexPath.row].logo == nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//filteredCards[indexPath.row].backgroundColor
            cell.barcodeView.image = fromString(string: filteredCards[indexPath.row].barcode)
            cell.labelView.text = filteredCards[indexPath.row].title
            cell.linkToWallet = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (!isFiltering() && Wallet.shared.cards[indexPath.row].logo != nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! cardCollectionCellImage
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//cards[indexPath.row].backgroundColor
            cell.logoView.image = UIImage(named: Wallet.shared.cards[indexPath.row].logo!)//loadImage(fileName: cards[indexPath.row].logo!)
            cell.barcodeView.image = fromString(string: Wallet.shared.cards[indexPath.row].barcode)
            cell.linkToWallet = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (!isFiltering() && Wallet.shared.cards[indexPath.row].logo == nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//cards[indexPath.row].backgroundColor
            cell.barcodeView.image = fromString(string: Wallet.shared.cards[indexPath.row].barcode)
            cell.labelView.text = Wallet.shared.cards[indexPath.row].title
            cell.linkToWallet = self
            collectionView.scaledVisibleCells()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
        cell.index = indexPath.row
        cell.cellView.backgroundColor = Wallet.shared.cards[indexPath.row].backgroundColor
        cell.barcodeView.image = fromString(string: Wallet.shared.cards[indexPath.row].barcode)
        cell.labelView.text = Wallet.shared.cards[indexPath.row].title
        cell.linkToWallet = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Width = self.view.frame.width * 0.76
        let Height = self.view.frame.height * 0.65
        return CGSize(width: Width, height: Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 100)
    }
    
    func fromString(string : String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputCIImage = filter.outputImage {
                return UIImage(ciImage: outputCIImage)
            }
        }
        return nil
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.scaledVisibleCells()
    }
}

extension FavoirtesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        //collectionView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        collectionView.setScaledDesginParam(scaledPattern: .HorizontalCenter, maxScale: 1.2, minScale: 0.5, maxAlpha: 1.0, minAlpha: 0.7)
        
        collectionView.register(cardCollectionCellImage.self, forCellWithReuseIdentifier: cellIdentifier1)
        collectionView.register(cardCollectionCellLabel.self, forCellWithReuseIdentifier: cellIdentifier2)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    
    func collectionViewAdd() {
        collectionView.insertItems(at: [[0, cards.count - 1]])
        collectionView.scaledVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (isFiltering()) {
            return filteredCards.count
        }
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (isFiltering() && filteredCards[indexPath.row].logo != nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! cardCollectionCellImage
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//filteredCards[indexPath.row].backgroundColor
            cell.logoView.image = UIImage(named: cards[indexPath.row].logo!)
            cell.barcodeView.image = fromString(string: filteredCards[indexPath.row].barcode)
            cell.linkToFav = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (isFiltering() && filteredCards[indexPath.row].logo == nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//filteredCards[indexPath.row].backgroundColor
            cell.barcodeView.image = fromString(string: filteredCards[indexPath.row].barcode)
            cell.labelView.text = filteredCards[indexPath.row].title
            cell.linkToFav = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (!isFiltering() && Wallet.shared.cards[indexPath.row].logo != nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier1, for: indexPath) as! cardCollectionCellImage
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//cards[indexPath.row].backgroundColor
            cell.logoView.image = UIImage(named: cards[indexPath.row].logo!)//loadImage(fileName: cards[indexPath.row].logo!)
            cell.barcodeView.image = fromString(string: cards[indexPath.row].barcode)
            cell.linkToFav = self
            collectionView.scaledVisibleCells()
            return cell
        }
        else if (!isFiltering() && Wallet.shared.cards[indexPath.row].logo == nil) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
            cell.index = indexPath.row
            cell.cellView.backgroundColor = .white//cards[indexPath.row].backgroundColor
            cell.barcodeView.image = fromString(string: cards[indexPath.row].barcode)
            cell.labelView.text = cards[indexPath.row].title
            cell.linkToFav = self
            collectionView.scaledVisibleCells()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier2, for: indexPath) as! cardCollectionCellLabel
        cell.index = indexPath.row
        cell.cellView.backgroundColor = cards[indexPath.row].backgroundColor
        cell.barcodeView.image = fromString(string: cards[indexPath.row].barcode)
        cell.labelView.text = cards[indexPath.row].title
        cell.linkToFav = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Width = self.view.frame.width * 0.76
        let Height = self.view.frame.height * 0.65
        return CGSize(width: Width, height: Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 100)
    }
    
    func fromString(string : String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputCIImage = filter.outputImage {
                return UIImage(ciImage: outputCIImage)
            }
        }
        return nil
    }
    
}

extension FavoirtesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.scaledVisibleCells()
    }
}

