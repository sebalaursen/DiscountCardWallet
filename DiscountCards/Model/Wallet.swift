//
//  Cards.swift
//  DiscountCards
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

class Wallet {
    var cards = [card]()
    
    func add(card: card) {
        cards.append(card)
    }
    
    func delete(at index: Int) {
        cards.remove(at: index)
    }
    
    func edit(at index: Int) {
        //
    }
}
