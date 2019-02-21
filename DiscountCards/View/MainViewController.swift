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
    var prevState: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier1 = "CollectionCellImage"
    let cellIdentifier2 = "CollectionCellLabel"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchController()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cards"
        searchController.searchBar.tintColor = UIColor(red: 235/255, green: 70/255, blue: 145/255, alpha: 1)
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCards = cards.filter({( card : cardInfo) -> Bool in
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
        editController.card = cards[indexpath!.row]
        self.present(editController, animated: true, completion: nil)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        if (navigationItem.titleView != nil) {
            navigationItem.titleView = nil
        }
        else {
            prevState = navigationItem.leftBarButtonItem
            navigationItem.searchController = searchController
            navigationItem.searchController?.isActive = true
            navigationItem.leftBarButtonItem? = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(endSearchBtn))
            collectionView.scaledVisibleCells()
        }
    }
    
    @objc func endSearchBtn() {
        navigationItem.searchController = nil
        navigationItem.leftBarButtonItem? = prevState
        view.endEditing(true)
        collectionView.scaledVisibleCells()
    }
}

extension ViewController: cardDelegate {
    func addCard(card: cardInfo) {
        cards.append(card)
        coreData.add(logo: card.logo, title: card.title, barcode: card.barcode)
        collectionView.insertItems(at: [[0, cards.count - 1]])
        collectionView.scrollToItem(at: [0, cards.count - 1], at: .centeredHorizontally, animated: true)
        collectionView.scaledVisibleCells()
    }
    
    func removeCard(index: Int) {
        coreData.delete(at: index)
        cards.remove(at: index)
        collectionView.deleteItems(at: [[0, index]])
        collectionView.scaledVisibleCells()
    }
    
    func editCard(card: cardInfo, index: Int) {
        coreData.edit(logo: card.logo, title: card.title, barcode: card.barcode, at: index)
        cards[index].logo = card.logo
        cards[index].title = card.title
        collectionView.scaledVisibleCells()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
