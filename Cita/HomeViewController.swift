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
    
    @IBOutlet weak var containerView: UIView!
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
    
    var nothingFoundView: UILabel?
    var activities: [Activity]?
    var currentSearchFilter = Filter()
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
        
        nothingFoundView = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! +
            UIApplication.shared.statusBarFrame.height
            , width: self.view.frame.width, height: 30))
        nothingFoundView?.textAlignment = .center
        nothingFoundView?.isHidden = true
        nothingFoundView?.backgroundColor = UIColor.citaYellow
        nothingFoundView?.text = "No events found, try expanding your search area on the map"
        self.view.addSubview(nothingFoundView!)
        
        
        // UI Styling
        myActivitiesImageView.image = myActivitiesImageView.image!.withRenderingMode(.alwaysTemplate)
        myActivitiesImageView.tintColor = UIColor.citaRed
        
        newActivityImageView.image = newActivityImageView.image!.withRenderingMode(.alwaysTemplate)
        newActivityImageView.tintColor = UIColor.citaRed
        
        profileImageView.image = profileImageView.image!.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = UIColor.citaRed
        
        tabBarView.backgroundColor = UIColor.citaOrange
        newActivityView.backgroundColor = UIColor.citaOrange
        profileView.backgroundColor = UIColor.citaOrange
        
        newActivityView.layer.cornerRadius = 10
        newActivityView.clipsToBounds = true
        newActivityView.layer.borderWidth = 1
        newActivityView.layer.borderColor = UIColor.citaRed.cgColor
        
        let border = CALayer()
        border.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:1.0)
        border.backgroundColor = UIColor.citaRed.cgColor;
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
                print("got notif \(Activity.activitiesUpdated) with \(Activity.currentActivities?.count) activities")
                self.activities = Activity.currentActivities
                self.updateActivities()
        }
        

        
    }
    
    func populateMarkers() {
        mapView.clear()
        guard let activities = self.activities else {
            return
        }
        for activity in activities {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (activity.location?.latitude)!, longitude: (activity.location?.longitude)!)
            marker.title = activity.name
            /*
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "MMM d h:ma"
            let startDateString = dataFormatter.string(from: activity.startTime!)
            let endDateString = dataFormatter.string(from: activity.endTime!)
            */
            let time = Date.niceToRead(from: activity.startTime!, to: activity.endTime!, terse: true)
            marker.snippet = "\(time) \n(Tap for details)"
            
            marker.icon = UIImage(named: "marker_red.png")
//            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = self.mapView
            self.isNewMarker = false
        }
        
        if self.activities?.count == 0 {
            self.nothingFoundView?.isHidden = false
        } else {
            self.nothingFoundView?.isHidden = true
        }
        
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search test changed to \(searchText)")
        currentSearchFilter.searchTerm = searchText
        FirebaseClient.sharedInstance.observeActivities(filter: currentSearchFilter)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        currentSearchFilter.searchTerm = ""
        FirebaseClient.sharedInstance.observeActivities(filter: currentSearchFilter)
    }
    
    @IBAction func toggleMapListView(_ sender: Any) {
        if (toggleViewButton.title == "List") {
            toggleViewButton.title = "Map"
            self.view.backgroundColor = UIColor.black
            
            UIView.transition(with: containerView, duration: 0.75, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.mapView.isHidden = true
                self.tableView.isHidden = false
                
            }, completion: { finished in
                self.view.backgroundColor = UIColor.white
                
                if self.activities?.count == 0 {
                    self.nothingFoundView?.isHidden = false
                } else {
                    self.nothingFoundView?.isHidden = true
                }
                
            })
        } else {
            toggleViewButton.title = "List"
            self.view.backgroundColor = UIColor.black
            
            UIView.transition(with: containerView, duration: 0.75, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                self.mapView.isHidden = false
                self.tableView.isHidden = true
            }, completion: { finished in
                self.view.backgroundColor = UIColor.white
                
                if self.activities?.count == 0 {
                    self.nothingFoundView?.isHidden = false
                } else {
                    self.nothingFoundView?.isHidden = true
                }
                
            })
        }
    }

    @IBAction func filterSearchTap(_ sender: Any) {
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
        } else if segue.identifier == "SearchFilter" {
            let navigationController = segue.destination as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterViewController
            filterViewController.filter = currentSearchFilter
            filterViewController.delegate = self
        }
    }
    
    func updateActivities() {
        tableView.reloadData()
        populateMarkers()
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
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("map willMove")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("map didChange")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("map didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("map idleAt")
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds.init(region: visibleRegion)
        let upperRight = Location(lat: bounds.northEast.latitude, long: bounds.northEast.longitude)
        let lowerLeft = Location(lat: bounds.southWest.latitude, long: bounds.southWest.longitude)
        let locationFrame = LocationFrame(lowerLeft: lowerLeft, upperRight: upperRight)
        currentSearchFilter.locationFrame = locationFrame
        FirebaseClient.sharedInstance.observeActivities(filter: currentSearchFilter)
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
        return activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        cell.activity = activities?[indexPath.row]
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

extension HomeViewController: FilterViewControllerDelegate {
    func filterViewController(filterViewController: FilterViewController, filter: Filter) {
        print("applying filter with categories \(filter.categories)")
        currentSearchFilter = filter
        FirebaseClient.sharedInstance.observeActivities(filter: currentSearchFilter)
    }
}



