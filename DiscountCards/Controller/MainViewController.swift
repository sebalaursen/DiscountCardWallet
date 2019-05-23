//
//  ViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import ScaledVisibleCellsCollectionView

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var filteredCards: [card] = []
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier1 = "CollectionCellImage"
    let cellIdentifier2 = "CollectionCellLabel"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotifications()
        collectionView.scaledVisibleCells()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAddingCard), name: .addedCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRemovingCard(notif:)), name: .removedCard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEditingCard), name: .editedCard, object: nil)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cards"
        searchController.searchBar.tintColor = UIColor(red: 235/255, green: 70/255, blue: 145/255, alpha: 1)
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCards = Wallet.shared.cards.filter({( card : card) -> Bool in
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
        editController.delegate = self
        editController.cellIndex = indexpath!.row
        editController.card = Wallet.shared.cards[indexpath!.row]
        self.present(editController, animated: true, completion: nil)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
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

extension ViewController: cardDelegate {
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

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        view.endEditing(true)
        collectionView.scaledVisibleCells()
    }
}
