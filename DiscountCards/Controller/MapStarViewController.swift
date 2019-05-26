//
//  MapStarViewController.swift
//  DiscountCards
//
//  Created by Sebastian on /25/5/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class MapStarViewController: UIViewController {
    
    weak var parVC: UIViewController!
    //var UserTrackingBtn: MKUserTrackingButton!
    var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locManager = CoreLocationManadger()
    var name = ""
    
    
    var map: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    var favBtn: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Favorite", for: .normal)
        view.addTarget(self, action: #selector(favAction), for: .touchUpInside)
        view.backgroundColor = .white
        view.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        return view
    }()
    var mapBtn: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Find on map", for: .normal)
        view.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        view.backgroundColor = .white
        view.tintColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setup() {
        view.addSubview(topLine)
        view.addSubview(favBtn)
        view.addSubview(mapBtn)
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        topLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.9)
        topLine.layer.shadowColor = UIColor.black.cgColor
        topLine.layer.shadowOffset = CGSize(width: 0, height: 4)
        topLine.layer.shadowOpacity = 1
        topLine.layer.shadowRadius = 4
        topLine.layer.borderColor = UIColor.darkGray.cgColor
        
        favBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        favBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        favBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        favBtn.layer.shadowColor = UIColor.gray.cgColor
        favBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        favBtn.layer.shadowOpacity = 0.6
        favBtn.layer.shadowRadius = 1
        favBtn.layer.borderColor = UIColor.lightGray.cgColor
        favBtn.layer.cornerRadius = 15
        
        mapBtn.topAnchor.constraint(equalTo: favBtn.bottomAnchor, constant: 20).isActive = true
        mapBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        mapBtn.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        mapBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapBtn.layer.shadowColor = UIColor.gray.cgColor
        mapBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        mapBtn.layer.shadowOpacity = 0.6
        mapBtn.layer.shadowRadius = 1
        mapBtn.layer.borderColor = UIColor.lightGray.cgColor
        mapBtn.layer.cornerRadius = 15
        
    }
    
    func onDragOut() {
        if let vc = parVC as? ViewController {
            let cell = vc.getSelectedCell(cells: vc.collectionView.visibleCells)
            vc.collectionView.scrollToItem(at: vc.collectionView.indexPath(for: cell!)! , at: .centeredHorizontally, animated: true)
            vc.collectionView.isScrollEnabled = false
        } else if let vc = parVC as? FavoirtesViewController {
            let cell = vc.getSelectedCell(cells: vc.collectionView.visibleCells)
            vc.collectionView.scrollToItem(at: vc.collectionView.indexPath(for: cell!)! , at: .centeredHorizontally, animated: true)
            vc.collectionView.isScrollEnabled = false
        }
        
        locManager.stopTracking()
    }
    
    func setupMap() {
        if let vc = parVC as? ViewController {
            UIView.animate(withDuration: 0.3) {
                vc.view.frame.origin.y -= vc.view.frame.height * 0.4
                self.view.frame = CGRect(x: 0, y: vc.view.bounds.maxY, width: vc.view.frame.width, height: vc.view.frame.height * 0.65 )
            }
            let cell = vc.getSelectedCell(cells: vc.collectionView.visibleCells)
            name = Wallet.shared.cards[vc.collectionView.indexPath(for: cell!)!.row].title
        }
        favBtn.removeFromSuperview()
        mapBtn.removeFromSuperview()
        
        self.view.addSubview(map)
        map.showsUserLocation = true
        //UserTrackingBtn = MKUserTrackingButton(mapView: map)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(region, animated: true)
        
        map.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.9).isActive = true
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height)!).isActive = true
        
        print(RequestURL(latitude: Float(currentLocation.latitude), longitute: Float(currentLocation.longitude), locName: name, radius: Float(Settings.radius)))
        let fe = FetchData()
        fe.fetch(loc: currentLocation, name: name, radius: Float(Settings.radius), completion: {(resInfo) -> () in
            if let res = resInfo {
                for r in res.results {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(r.geometry.location.latitude)), longitude: CLLocationDegrees(Double(r.geometry.location.longitude)))
                    annotation.title = r.name
                    self.map.addAnnotation(annotation)
                }
            }
        })
        
        locManager.stopTracking()
        
    }
    
    @objc func favAction() {
        if let vc = parVC as? ViewController {
            let cell = vc.getSelectedCell(cells: vc.collectionView.visibleCells)!
            guard let index = vc.collectionView.indexPath(for: cell) else {return}
            if Wallet.shared.cards[index.row].isFav {
                Wallet.shared.cards[index.row].isFav = false
                cell.layer.borderWidth = 0
                
                let ed = Wallet.shared.cards[index.row]
                CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: false)
                
                ((self.tabBarController!.viewControllers![0] as? UINavigationController)?.viewControllers[0] as? ViewController)?.collectionView.scaledVisibleCells()
            } else {
                Wallet.shared.cards[index.row].isFav = true
                cell.layer.cornerRadius = 16
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1).cgColor
                
                let ed = Wallet.shared.cards[index.row]
                CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: true)
            }
            
        } else if let vc = parVC as? FavoirtesViewController {
            let cell = vc.getSelectedCell(cells: vc.collectionView.visibleCells)!
            guard let index = vc.collectionView.indexPath(for: cell) else {return}
            if Wallet.shared.cards[index.row].isFav {
                Wallet.shared.cards[index.row].isFav = false
                cell.layer.borderWidth = 0
                
                let ed = Wallet.shared.cards[index.row]
                CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: false)
                vc.collectionView.scaledVisibleCells()
                vc.hideMapStar()
                
                ((self.tabBarController!.viewControllers![1] as? UINavigationController)?.viewControllers[0] as? FavoirtesViewController)?.collectionView.scaledVisibleCells()
            } else {
                Wallet.shared.cards[index.row].isFav = true
                cell.layer.cornerRadius = 16
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(red: 15/255, green: 186/255, blue: 3/255, alpha: 1).cgColor
                
                let ed = Wallet.shared.cards[index.row]
                CoreDataStack().edit(logo: ed.logo, title: ed.title, barcode: ed.barcode, at: index.row, fav: true)
            }
        }
    }
    
    @objc func mapAction() {
        locManager.startTracking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setupMap()
        }
    }
}

extension MapStarViewController: CoreLocDelegate {
    func getCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        currentLocation.latitude = lat
        currentLocation.longitude = lon
    }
    
    func alertLocationAccess() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need location tracking access",
            message: "Is needed to use this app",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
