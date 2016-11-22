//
//  ViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tabBarView: UIView!
    
    var activities: [Activity]?
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var newActivityMarker: GMSMarker! = nil
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.77, longitude: -122.42, zoom: 15.0)
        mapView.camera = camera
        
//        searchBar.delegate = self
//        searchBar.placeholder = "Enter address or drop pin on map"
//        self.navigationItem.titleView = self.searchBar
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        self.definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Activity.activitiesUpdated),
            object: nil, queue: OperationQueue.main) {
                (notification: Notification) in
                self.activities = Activity.currentActivities
                self.populateMarkers()
        }
    }
    
    func populateMarkers() {
        for activity in self.activities! {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (activity.location?.latitude)!, longitude: (activity.location?.longitude)!)
            marker.title = activity.name
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "MMM d h:ma"
            let startDateString = dataFormatter.string(from: activity.startTime!)
            let endDateString = dataFormatter.string(from: activity.endTime!)
            marker.snippet = "\(startDateString) - \(endDateString) \n(Tap for details)"
            
            marker.icon = UIImage(named: "marker_red.png")
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = self.mapView
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(dataString: Business) -> Bool in
//            return dataString.name?.range(of: searchText, options: .caseInsensitive) != nil
//        })
//        
//        tableView.reloadData()
//    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchBar.showsCancelButton = true
//    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        self.filteredBusinesses = businesses
//        tableView.reloadData()
//    }
    
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
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewActivitySegue" {
            let marker = sender as! GMSMarker
            let location = Location(lat: marker.position.latitude, long: marker.position.longitude)
            let activityEditViewController = segue.destination as! ActivityEditController
            activityEditViewController.markerLocation = location
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
        if (self.newActivityMarker != nil) {
            self.newActivityMarker.map = nil
        }
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.snippet = "Tap here to create new activity"
        marker.icon = UIImage(named: "marker_green.png")
        marker.tracksInfoWindowChanges = true
        marker.isDraggable = true
        marker.map = self.mapView
        mapView.selectedMarker = marker
        self.newActivityMarker = marker
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "NewActivitySegue", sender: marker)
        marker.map = nil
    }
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.mapView.camera = camera
        
        if (self.newActivityMarker != nil) {
            self.newActivityMarker.map = nil
        }
        
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.snippet = "Tap here to create new activity"
        marker.icon = UIImage(named: "marker_green.png")
        marker.tracksInfoWindowChanges = true
        marker.isDraggable = true
        marker.map = self.mapView
        mapView.selectedMarker = marker
        self.newActivityMarker = marker
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



