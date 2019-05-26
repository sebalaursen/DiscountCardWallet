//
//  ViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import ScaledVisibleCellsCollectionView
import AVFoundation

class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let scannerManager = ScannerManager()
    private let mapStarView = MapStarViewController()
    let cellIdentifier1 = "CollectionCellImage"
    let cellIdentifier2 = "CollectionCellLabel"
    var filteredCards: [card] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchController()
        hideKeyboardWhenTappedAround()
        panGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotifications()
        collectionView.scaledVisibleCells()
        setup()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAddingCard), name: .addedCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRemovingCard(notif:)), name: .removedCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEditingCard), name: .editedCard, object: nil)
    }
    
    private func setup() {
        mapStarView.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: self.view.bounds.maxY * 0.35)
        mapStarView.parVC = self
        
        self.addChild(mapStarView)
        self.view.addSubview(mapStarView.view)
    }
    
    private func panGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc private func handleGesture(sender: UIPanGestureRecognizer) {
        
        if Wallet.shared.cards.count != 0 {
            if sender.velocity(in: self.view).y < 0 {
                UIView.animate(withDuration: 0.3) {
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= self.mapStarView.view.frame.height
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    if self.view.frame.origin.y == -self.mapStarView.view.frame.height {
                        self.view.frame.origin.y += self.mapStarView.view.frame.height
                    }
                }
            }
        }
        
        collectionView.scaledVisibleCells() //need?
    }
    
    func hideMapStar() {
        if self.view.frame.origin.y == -self.mapStarView.view.frame.height {
            self.view.frame.origin.y += self.mapStarView.view.frame.height
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cards"
        searchController.searchBar.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCards = Wallet.shared.cards.filter({( card : card) -> Bool in
            return card.title.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func getSelectedCell(cells: [UICollectionViewCell]) -> UICollectionViewCell? {
        if (!cells.isEmpty) {
            var max = cells[0]
            if (cells.count == 1) {
                return max
            }
            for cell in cells {
                if (max.frame.height < cell.frame.height) {
                    max = cell
                }
                else if (cell == cells.last && max.frame.height == cell.frame.height) {
                    return nil
                }
            }
            return max
        }
        return nil
    }
    
    func addToFavs(cell: cardCollectionCellImage?, cell1: cardCollectionCellLabel?) {
        if let cel = cell {
            guard let index = collectionView.indexPath(for: cel) else {return}
            cel.starButton.tintColor = .yellow
            Wallet.shared.cards[index.row].isFav = true
            
            let ed = Wallet.shared.cards[index.row]
            CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: true)
        } else if let cel = cell1 {
            guard let index = collectionView.indexPath(for: cel) else {return}
            cel.starButton.tintColor = .yellow
            Wallet.shared.cards[index.row].isFav = true
            
            let ed = Wallet.shared.cards[index.row]
            CoreDataStack().edit(logo: nil, title: ed.title, barcode: ed.barcode, at: index.row, fav: true)
        }
    }
    
    func removeFromFavs(cell: cardCollectionCellImage?, cell1: cardCollectionCellLabel?) {
        if let cel = cell {
            guard let index = collectionView.indexPath(for: cel) else {return}
            cel.starButton.tintColor = .darkGray
            Wallet.shared.cards[index.row].isFav = false
            
            let ed = Wallet.shared.cards[index.row]
            CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: false)
        } else if let cel = cell1 {
            guard let index = collectionView.indexPath(for: cel) else {return}
            cel.starButton.tintColor = .darkGray
            Wallet.shared.cards[index.row].isFav = false
            
            let ed = Wallet.shared.cards[index.row]
            CoreDataStack().edit(logo: nil, title: ed.title, barcode: ed.barcode, at: index.row, fav: false)
        }
    }
    
    @IBAction private func editBtn(_ sender: Any) {
        let cells = collectionView.visibleCells
        guard let selectedCell = getSelectedCell(cells: cells) else {
            return
        }
        let indexpath = collectionView.indexPath(for: selectedCell)
        
        let editController = storyboard!.instantiateViewController(withIdentifier: "editVC") as! EditViewController
        editController.delegate = self
        editController.cellIndex = indexpath!.row
        editController.card = Wallet.shared.cards[indexpath!.row]
        self.present(editController, animated: true, completion: nil)
    }
    @IBAction private func addBtn(_ sender: Any) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: scannerManager.requestCameraPermission()
        case .authorized:
            scannerManager.showScanner(viewController: self)
        case .restricted, .denied: scannerManager.alertCameraAccessNeeded(viewController: self)
        @unknown default:
            print("error")
        }
    }
    
    @IBAction private func searchBtn(_ sender: Any) {
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = true
        collectionView.scaledVisibleCells()
    }
    
    @objc func onAddingCard() {
        collectionView.insertItems(at: [[0, Wallet.shared.cards.count - 1]])
        collectionView.scrollToItem(at: [0, Wallet.shared.cards.count - 1], at: .centeredHorizontally, animated: true)
        collectionView.scaledVisibleCells()
    }
    
    @objc func onRemovingCard(notif: Notification) {
        if let userInfo = notif.userInfo as? [Int : Int] {
            if let index = userInfo[0] {
                collectionView.deleteItems(at: [[0, index]])
                collectionView.scaledVisibleCells()
            }
        }
    }
    
    @objc func onEditingCard() {
        collectionView.scaledVisibleCells()
    }
}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate, cardDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        view.endEditing(true)
        collectionView.scaledVisibleCells()
    }
    
    func addCard(card: card) {
        Wallet.shared.add(card)
    }
    
    func removeCard(index: Int) {
        Wallet.shared.remove(at: index)
    }
    
    func editCard(card: card, index: Int) {
        Wallet.shared.edit(at: index, to: card)
    }
}
