//
//  MVController.swift
//  DCC
//
//  Created by Sebastian on /16/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

var cards: [cardInfo] = [cardInfo(backgroundColor: .white, logo: "CCC", barcode: "4293905411", title: "CCC"), cardInfo(backgroundColor: .white, logo: "Рукавичка", barcode: "4294275411", title: "Rukavychka"), cardInfo(backgroundColor: .white, logo: "Watsons", barcode: "8956605411", title: "Watsons"), cardInfo(backgroundColor: .white, logo: nil, barcode: "84583405", title: "apteka")]
var filteredCards: [cardInfo] = []
var selectedItemIndex: Int?
let coreData = CoreDataStack()

class MVController {
    
}
