//
//  CoreLocationManager.swift
//  DiscountCards
//
//  Created by Sebastian on /26/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import CoreLocation

protocol CoreLocDelegate: class {
    func getCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func alertLocationAccess()
}

class CoreLocationManadger:  NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    weak var delegate: CoreLocDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation//kCLLocationAccuracyBest
    }
    
    func startTracking() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            delegate!.alertLocationAccess()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func stopTracking() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate!.getCoordinates(lat: locations[0].coordinate.latitude, lon: locations[0].coordinate.longitude)
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
    }
}
