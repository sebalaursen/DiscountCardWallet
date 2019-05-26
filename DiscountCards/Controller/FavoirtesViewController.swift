//
//  FavoirtesViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /23/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import ScaledVisibleCellsCollectionView
import AVFoundation

class FavoirtesViewController: UIViewController {

    private let mapStarView = MapStarViewController()
    var collectionView: UICollectionView!
    var filteredCards: [card] = []
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier1 = "CollectionCellImage"
    let cellIdentifier2 = "CollectionCellLabel"
    let scannerManager = ScannerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchController()
        hideKeyboardWhenTappedAround()
        setupNotifications()
        panGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        collectionView.scaledVisibleCells()
        setup()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAddingCard), name: .addedFavCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRemovingCard(notif:)), name: .removedFavCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEditingCard), name: .editedCard, object: nil)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cards"
        searchController.searchBar.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    private func setup() {
        mapStarView.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: self.view.bounds.maxY * 0.25)
        mapStarView.parVC = self
        
        self.addChild(mapStarView)
        self.view.addSubview(mapStarView.view)
    }
    
    private func panGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc private func handleGesture(sender: UIPanGestureRecognizer) {
        
        if Wallet.shared.hasFavs() {
            if sender.velocity(in: self.view).y < 0 {
                UIView.animate(withDuration: 0.3) {
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= self.mapStarView.view.frame.height
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations:  {
                    if self.view.frame.origin.y == -self.mapStarView.view.frame.height {
                        self.view.frame.origin.y += self.mapStarView.view.frame.height
                    }
                    else if self.view.bounds.maxY - self.view.frame.height * 0.35 == self.view.frame.height * 0.65 {
                        self.view.frame.origin.y -= self.view.frame.origin.y
                        self.mapStarView.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: self.view.bounds.maxY * 0.25)
                    }
                }) { (finished) in
                    self.mapStarView.map.removeFromSuperview()
                    self.mapStarView.setup()
                    self.collectionView.isScrollEnabled = true
                }
            }
        }
        collectionView.scaledVisibleCells()
    }
    
    func hideMapStar() {
        if self.view.frame.origin.y == -self.mapStarView.view.frame.height {
            self.view.frame.origin.y += self.mapStarView.view.frame.height
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCards = Wallet.shared.getFavs().filter({( card : card) -> Bool in
            return card.title.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func getSelectedCell(cells: [UICollectionViewCell]) -> UICollectionViewCell? {
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
    
    @IBAction func editBtn(_ sender: Any) {
        let cells = collectionView.visibleCells
        guard let selectedCell = getSelectedCell(cells: cells) else {
            return
        }
        let indexpath = collectionView.indexPath(for: selectedCell)
        
        let editController = storyboard!.instantiateViewController(withIdentifier: "editVC") as! EditViewController
        editController.delegate1 = self
        editController.cellIndex = indexpath!.row
        editController.card = Wallet.shared.getFavs()[indexpath!.row]
        self.present(editController, animated: true, completion: nil)
    }
    
    @IBAction func addBtn(_ sender: Any) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: scannerManager.requestCameraPermission()
        case .authorized:
            scannerManager.showScannerr(viewController: self)
        case .restricted, .denied: scannerManager.alertCameraAccessNeeded(viewController: self)
        @unknown default:
            print("error")
        }
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = true
        collectionView.scaledVisibleCells()
    }
    
    @objc func onAddingCard() {
        collectionView.reloadData()
        collectionView.scaledVisibleCells()
        ((self.tabBarController!.viewControllers![1] as? UINavigationController)?.viewControllers[0] as? FavoirtesViewController)?.collectionView.reloadData()
    }
    
    @objc func onRemovingCard(notif: Notification) {
        collectionView.reloadData()
        ((self.tabBarController!.viewControllers![1] as? UINavigationController)?.viewControllers[0] as? FavoirtesViewController)?.collectionView.reloadData()
    }
    
    @objc func onEditingCard() {
        collectionView.scaledVisibleCells()
    }
}

extension FavoirtesViewController: UISearchResultsUpdating, UISearchBarDelegate, favCardDelegate {
    func addCard(card: card) {
        Wallet.shared.addFav(card)
    }
    
    func removeCard(index: Int) {
        Wallet.shared.removeFav(at: index)
    }
    
    func editCard(card: card, index: Int) {
        Wallet.shared.edit(at: index, to: card)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        view.endEditing(true)
        collectionView.scaledVisibleCells()
    }
}
