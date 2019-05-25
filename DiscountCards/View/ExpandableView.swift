//
//  starMapView.swift
//  DiscountCards
//
//  Created by Sebastian on /25/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class ExpandableView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }
        
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        
        return nil
    }

}
