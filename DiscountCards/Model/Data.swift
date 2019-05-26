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
    
//    let formatted_address : String
    let geometry : Location
    let name : String
    
    
//    enum CodingKeys : String, CodingKey {
//        case geometry = "geometry"
//        case name = "name"
//        case openingHours = "opening_hours"
//        case photos = "photos"
//        case types = "types"
//        case address = "vicinity"
//    }
    
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
    
    struct OpenNow : Decodable {
        
        let isOpen : Bool
        
        enum CodingKeys : String, CodingKey {
            case isOpen = "open_now"
        }
    }
    
    struct PhotoInfo : Decodable {
        
        let height : Int
        let width : Int
        let photoReference : String
        
        enum CodingKeys : String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
}
