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
    var description: String?
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
        description = dictionary["description"] as? String
        if let url = dictionary["imag_url"] as? String {
            imageURL = URL(string: url)
        }
        location = CLLocation(latitude: dictionary["latitude"] as? CLLocationDegrees, longitude: dictionary["longitude"] as? CLLocationDegrees)
        startTime = Date(timeIntervalSinceReferenceDate: dictionary["start_time"] as? Int)
        endTime = Date(timeIntervalSinceReferenceDate: dictionary["end_time"] as? Int)
        // TODO: init address
        if let addressDictionary = dictionary["address"] as? NSDictionary {
            address = Address(addressDictionary)
        }
    }
}
