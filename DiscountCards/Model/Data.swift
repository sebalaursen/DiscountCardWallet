//
//  Data.swift
//  DiscountCards
//
//  Created by Sebastian on /26/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

struct GooglePlacesResponse : Decodable {
    let results : [Place]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
}

struct Place : Decodable {
    
    let geometry : Location
    let name : String
    
    
    enum CodingKeys : String, CodingKey {
        case geometry = "geometry"
        case name = "name"
    }
    
    struct Location : Decodable {
        
        let location : LatLong
        
        enum CodingKeys : String, CodingKey {
            case location = "location"
        }
        
        struct LatLong : Codable {
            
            let latitude : Double
            let longitude : Double
            
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
}
