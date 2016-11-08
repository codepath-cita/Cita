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
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.77, longitude: -122.42, zoom: 15.0)
        let googleMapView = GMSMapView.map(withFrame: frame, camera: camera)
        googleMapView.isMyLocationEnabled = true
        mapView.addSubview(googleMapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.77, longitude: -122.42)
        marker.title = "Here"
        marker.snippet = "you wish you were"
        marker.map = googleMapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

