//
//  Model.swift
//  DiscountCards
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

struct cardInfo: Equatable, Hashable {
    var backgroundColor: UIColor
    var logo: String?
    var barcode: String
    var title: String
    
    init(backgroundColor: UIColor, logo: String?, barcode: String, title: String) {
        self.backgroundColor = backgroundColor
        self.logo = logo
        self.barcode = barcode
        self.title = title
    }
    
    var hashValue: Int {
        return Int(barcode)!
    }
    
    static func == (lhs: cardInfo, rhs: cardInfo) -> Bool {
        return lhs.barcode == rhs.barcode
    }
    
}
