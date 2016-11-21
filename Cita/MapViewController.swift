//
//  ViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tabBarView: UIView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.black
//        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
//        
//        let camera = GMSCameraPosition.camera(withLatitude: 37.77, longitude: -122.42, zoom: 15.0)
//        let googleMapView = GMSMapView.map(withFrame: frame, camera: camera)
//        googleMapView.isMyLocationEnabled = true
//        mapView.addSubview(googleMapView)
//        
//        if let mylocation = googleMapView.myLocation {
//            print("User's location: \(mylocation)")
//        } else {
//            print("User's location is unknown")
//        }
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.42)
//        marker.title = "Here"
//        marker.snippet = "you wish you were"
//        marker.map = googleMapView
        

//        seenError = false
//        locationFixAchieved = false
//        myLocationManager = CLLocationManager()
//        myLocationManager.delegate = self
//        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
//        myLocationManager.requestAlwaysAuthorization()
//        myLocationManager.startUpdatingLocation()
        
        
//        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
//        mapView.camera = camera
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                let addressString = lines.joined(separator: "\n")
                print(addressString)
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(coordinate: position.target)
    }
}


