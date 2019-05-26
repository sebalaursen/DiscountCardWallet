//
//  Cards.swift
//  DiscountCards
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class Wallet {
    static let shared = Wallet()
    
    var owner: String!
    var cards: [card] = []
    
    private init() {}
    
    func add(_ card: card) {
        if cards.contains(card) {
            
        } else {
            cards.append(card)
            CoreDataStack().add(logo: card.logo, title: card.title, barcode: card.barcode)
            NotificationCenter.default.post(name: .addedCard, object: nil)
        }
    }
    
    func remove(at index: Int) {
        cards.remove(at: index)
        CoreDataStack().delete(at: index)
        NotificationCenter.default.post(name: .removedCard, object: nil, userInfo: [0:index])
    }
    
    func edit(at index: Int, to card: card) {
        cards[index].logo = card.logo
        cards[index].title = card.title
        CoreDataStack().edit(logo: card.logo, title: card.title, barcode: card.barcode, at: index)
        NotificationCenter.default.post(name: .editedCard, object: nil)
    }
    
    func getFavs() -> [card] {
        var res: [card] = []
        for c in cards {
            if c.isFav {
                res.append(c)
            }
        }
        return res
    }
    
    func hasFavs() -> Bool {
        for c in cards {
            if c.isFav {
                return true
            }
        }
        return false
    }
}
