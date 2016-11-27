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
    @IBOutlet weak var toggleViewButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var activities: [Activity]?
    var filteredActivities: [Activity]?
    var searchBar = UISearchBar()
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var newActivityMarker: GMSMarker! = nil
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var isNewMarker: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
        
        if Activity.currentActivities != nil {
            activities = Activity.currentActivities
            filteredActivities = activities
            tableView.reloadData()
            populateMarkers()
        }
        
        toggleViewButton.title = "List"
        let camera = GMSCameraPosition.camera(withLatitude: 37.77, longitude: -122.42, zoom: 15.0)
        mapView.camera = camera
        
        searchBar.delegate = self
        searchBar.placeholder = "Search for an activity"
        self.navigationItem.titleView = self.searchBar
        
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
//        searchController?.searchBar.placeholder = "Enter address to create activity"
//        self.navigationItem.titleView = searchController?.searchBar
//        self.definesPresentationContext = true
//        searchController?.hidesNavigationBarDuringPresentation = false
//        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Activity.activitiesUpdated),
            object: nil, queue: OperationQueue.main) {
                (notification: Notification) in
                self.activities = Activity.currentActivities
                self.filteredActivities = self.activities
                self.tableView.reloadData()
                self.populateMarkers()
        }
    }
    
    func populateMarkers() {
        mapView.clear()
        for activity in self.filteredActivities! {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (activity.location?.latitude)!, longitude: (activity.location?.longitude)!)
            marker.title = activity.name
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "MMM d h:ma"
            let startDateString = dataFormatter.string(from: activity.startTime!)
            let endDateString = dataFormatter.string(from: activity.endTime!)
            marker.snippet = "\(startDateString) - \(endDateString) \n(Tap for details)"
            
            marker.icon = UIImage(named: "marker_red.png")
//            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = self.mapView
            self.isNewMarker = false
        }
    }
    
    @IBAction func toggleMapListView(_ sender: Any) {
        if (toggleViewButton.title == "List") {
            toggleViewButton.title = "Map"
            mapView.isHidden = true
            tableView.isHidden = false
        } else {
            toggleViewButton.title = "List"
            tableView.isHidden = true
            mapView.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredActivities = searchText.isEmpty ? activities : activities?.filter({(dataString: Activity) -> Bool in
            return dataString.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
        populateMarkers()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredActivities = activities
        tableView.reloadData()
        populateMarkers()
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
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewActivitySegue" {
            let marker = sender as! GMSMarker
            let location = Location(lat: marker.position.latitude, long: marker.position.longitude)
            
            let navigationController = segue.destination as! UINavigationController
            let activityEditViewController = navigationController.topViewController as! ActivityEditController
            activityEditViewController.markerLocation = location
        } else if segue.identifier == "ActivityDetailSegue" {
            let marker = sender as! GMSMarker
            var selectedIndex = Int()
            var counter = 0
            for activity in self.activities! {
                if (activity.name == marker.title) {
                    selectedIndex = counter
                }
                counter += 1
            }
            
            let activity = self.activities?[selectedIndex]
            let activityDetailViewController = segue.destination as! ActivityDetailViewController
            activityDetailViewController.activity = activity
//            activity?.fetchAtendees()
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
        self.isNewMarker = true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if (self.isNewMarker == true) {
            self.performSegue(withIdentifier: "NewActivitySegue", sender: marker)
            marker.map = nil
        } else {
            self.performSegue(withIdentifier: "ActivityDetailSegue", sender: marker)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.isNewMarker = false
        
        return false
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

extension MapViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, tableDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActivities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        cell.activity = filteredActivities?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableDelegate(activity: Activity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activityDetailViewController = storyboard.instantiateViewController(withIdentifier: "ActivityDetailViewController") as! ActivityDetailViewController
        activityDetailViewController.activity = activity
        self.navigationController?.pushViewController(activityDetailViewController, animated: true)
    }
}



