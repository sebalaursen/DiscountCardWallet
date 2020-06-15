//
//  FetchData.swift
//  DiscountCards
//
//  Created by Sebastian on /26/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation
import CoreLocation

struct RequestURL {
    var url: URLComponents

    init (latitude:  Float, longitute: Float, locName: String, radius: Float) {
        url = URLComponents()
        url.scheme = "https"
        url.host = "maps.googleapis.com"
        url.path = "/maps/api/place/nearbysearch/json"
        url.queryItems = [
            URLQueryItem(name: "location=49.775297, 24.080715", value: ""),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "keyword", value: locName),
            URLQueryItem(name: "key", value: "AIzaSyAd3le1hBYfOTj4X3bkrUfcS3pinlr2KSs")

        ]
    }
}

class FetchData {
    
    func fetch(loc: CLLocationCoordinate2D, name: String, radius: Float, completion: @escaping (_ resInfo: GooglePlacesResponse?) -> () ) {
        let str = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + "\(loc.latitude)"+",\(loc.longitude)"+"&radius="+"\(radius)"+"&keyword="+name+"&key=AIzaSyAd3le1hBYfOTj4X3bkrUfcS3pinlr2KSs"
        
        print(str)
        //"https://maps.googleapis.com/maps/api/place/textsearch/json?query=rukavychka+in+Lviv&key=AIzaSyAd3le1hBYfOTj4X3bkrUfcS3pinlr2KSs"
        let url = URL(string: str)
        
        URLSession.shared.dataTask(with: url!) { (data,_ ,err) in
            DispatchQueue.main.async {
                if err != nil {
                    print("Failed to fentch data from url ", url!)
                    return
                }
                else {
                    guard let data = data else { return }
                    
                    do {
                        let res = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                        let resInfo = res
                        return completion(resInfo)
                    } catch let jsonErr {
                        print("Failed to decode JSON ", jsonErr)
                    }
                }
            }
            }.resume()
    }
}
