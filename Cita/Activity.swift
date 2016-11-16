//
//  Activity.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import CoreLocation
import UIKit

/*
 id
 name
 description
 image_url
 latitude
 longitude
 start_time
 end_time
 address_id
 chat_id
 created_at
 updated_at
 */
class Activity: NSObject {
    var id: String?
    var name: String?
    var descriptionString: String?
    var imageURL: URL?
    var location: CLLocation?
    var startTime: Date?
    var endTime: Date?
    var address: Address?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        descriptionString = dictionary["description"] as? String
//        if let url = dictionary["image_url"] as? String {
//            imageURL = URL(string: url)
//        }
        location = CLLocation(latitude: dictionary["latitude"] as! CLLocationDegrees, longitude: dictionary["longitude"] as! CLLocationDegrees)
        startTime = Date(timeIntervalSinceReferenceDate: dictionary["start_time"] as! Double)
        endTime = Date(timeIntervalSinceReferenceDate: dictionary["end_time"] as! Double)
        // TODO: init address
//        if let addressDictionary = dictionary["address"] as? NSDictionary {
//            address = Address(dictionary: addressDictionary)
//        }
    }
    
    class var testActivities: [Activity] {
        get {
            let sf_lat = 37.77
            let sf_long = -122.42
            let startDate = Date(timeIntervalSinceNow: 3*60*60).iso8601
            let endDate = Date(timeIntervalSinceNow: 5*60*60).iso8601
            let dictionaries = [
                ["id": 1, "name": "Get drinks", "description": "get drinks with me", "latitude": sf_lat, "longitude": sf_long, "start_time": startDate, "end_time": endDate],
                ["id": 2, "name": "Eat chocolate", "description": "eat chocolate with me", "latitude": sf_lat+0.09, "longitude": sf_long+0.06, "start_time": startDate, "end_time": endDate],
                ["id": 1, "name": "Play tennis", "description": "play tennis with me", "latitude": sf_lat+0.02, "longitude": sf_long-0.04, "start_time": startDate, "end_time": endDate]
            ]
            var activities = [Activity]()
            for dictionary in dictionaries {
                activities.append(Activity(dictionary: dictionary as NSDictionary))
            }
            
            return activities
        }
    }
    
}
