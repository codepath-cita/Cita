//
//  HomeViewController.swift
//  Cita
//
//  Created by Sara Hender on 11/7/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var toggleViewButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newActivityView: UIView!
    @IBOutlet weak var myActivitiesView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var myActivitiesImageView: UIImageView!
    @IBOutlet weak var newActivityImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var activities: [Activity]?
    var filteredActivities: [Activity]?
    var searchBar = UISearchBar()
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var newActivityMarker: GMSMarker! = nil
    var searchController: UISearchController?
    var searchTerm: String?
    var resultView: UITextView?
    var isNewMarker: Bool! = false
    var reversedAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Styling
        myActivitiesImageView.image = myActivitiesImageView.image!.withRenderingMode(.alwaysTemplate)
        myActivitiesImageView.tintColor = UIColor.citaRed()
        newActivityImageView.image = newActivityImageView.image!.withRenderingMode(.alwaysTemplate)
        newActivityImageView.tintColor = UIColor.citaRed()
        profileImageView.image = profileImageView.image!.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = UIColor.citaRed()
        
        newActivityView.layer.cornerRadius = 10
        newActivityView.clipsToBounds = true
        newActivityView.layer.borderWidth = 1
        newActivityView.layer.borderColor = UIColor.citaRed().cgColor
        
        let border = CALayer()
        border.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:1.0)
        border.backgroundColor = UIColor.citaRed().cgColor;
        tabBarView.layer.addSublayer(border)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")
 
        // a hacky bug fix to work around auto layouts factoring in two navigation bar heights
        let topViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal
            , toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topViewTopConstraint])
 
        // hide empty cells
        tableView.tableFooterView = UIView()
        
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
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: Activity.activitiesUpdated),
            object: nil, queue: OperationQueue.main) {
                (notification: Notification) in
                self.activities = Activity.currentActivities
                self.updateFilteredActivities()
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
        searchTerm = searchText
        updateFilteredActivities()
        
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
    
    @IBAction func myActivitiesTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "MyActivitiesSegue", sender: nil)
    }
    
    @IBAction func profileTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
    
    @IBAction func newActivityTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "NewActivitySegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D){
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                let addressString = lines.joined(separator: ",")
                self.reversedAddress = addressString
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewActivitySegue" {
            if (sender != nil) {
                let marker = sender as! GMSMarker
                let location = Location(lat: marker.position.latitude, long: marker.position.longitude)
                
                let navigationController = segue.destination as! UINavigationController
                let activityEditViewController = navigationController.topViewController as! ActivityEditController
                activityEditViewController.location = location
                print(self.reversedAddress)
                activityEditViewController.locationAddress = self.reversedAddress
            }
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
    
    func updateFilteredActivities() {
        let currentTerm = searchTerm ?? ""
        self.filteredActivities = currentTerm.isEmpty ? activities : activities?.filter({(activity: Activity) -> Bool in
            let nameMatch = activity.name?.range(of: currentTerm, options: .caseInsensitive)
            let descMatch = activity.fullDescription?.range(of: currentTerm, options: .caseInsensitive)
            return nameMatch != nil || descMatch != nil
        })
    }
}

extension HomeViewController: CLLocationManagerDelegate {
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

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {        
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
        reverseGeocodeCoordinate(coordinate: marker.position)
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, tableDelegate {
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



