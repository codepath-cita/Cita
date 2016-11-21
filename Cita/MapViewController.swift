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
    
    var activities: [Activity]?
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    let coordinatesArray = [
        CLLocationCoordinate2D(latitude: 37.79127729694, longitude: -122.4045503139537),
        CLLocationCoordinate2D(latitude: 37.7868853321233, longitude: -122.401074171066),
        CLLocationCoordinate2D(latitude: 37.7884115270977, longitude: -122.40972161293),
        CLLocationCoordinate2D(latitude: 37.785206481246, longitude: -122.412039041519),
        CLLocationCoordinate2D(latitude: 37.7813907692344, longitude: -122.41042971611),
        CLLocationCoordinate2D(latitude: 37.7821030504304, longitude: -122.406545877457),
        CLLocationCoordinate2D(latitude: 37.7798813887785, longitude: -122.404271364212),
        CLLocationCoordinate2D(latitude: 37.7833580053606, longitude: -122.401095628738),
        CLLocationCoordinate2D(latitude: 37.7784737365338, longitude: -122.411395311356)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.77, longitude: -122.42, zoom: 15.0)
        mapView.camera = camera        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Activity.activitiesUpdated),
            object: nil, queue: OperationQueue.main) {
                (notification: Notification) in
                self.activities = Activity.currentActivities
                dump(self.activities)
                self.populateMarkers()
        }
    }
    
    func populateMarkers() {
        for activity in self.activities! {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (activity.location?.latitude)!, longitude: (activity.location?.longitude)!)
            marker.title = "Here"
            marker.snippet = "you wish you were"
            marker.icon = UIImage(named: "marker_red.png")
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = self.mapView
        }
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
        //reverseGeocodeCoordinate(coordinate: position.target)
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds.init(region: visibleRegion)
        let upperRight = Location(lat: bounds.northEast.latitude, long: bounds.northEast.longitude)
        let lowerLeft = Location(lat: bounds.southWest.latitude, long: bounds.southWest.longitude)
        let locationFrame = LocationFrame(lowerLeft: lowerLeft, upperRight: upperRight)
        FirebaseClient.sharedInstance.observeActivities(within: locationFrame, searchTerm: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = "Here"
        marker.snippet = "you wish you were"
        marker.icon = UIImage(named: "marker_blue.png")
        marker.map = self.mapView
    }
}




