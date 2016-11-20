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
    static let dataRoot = "activities"
    static let activitiesUpdated = "activities:updated"
    
    var dictionary: NSDictionary?
    var id: String?
    var name: String?
    var fullDescription: String?
    var groupSize: Int?
    var imageURL: URL?
    var location: Location?
    var startISO8601: String?
    var endISO8601: String?
    var startTime: Date?
    var endTime: Date?
    var address: Address?
    var createdAt: Date?
    var updatedAt: Date?
    
    static var currentActivities: [Activity]? = []
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        fullDescription = dictionary["full_description"] as? String

        if let locationString = dictionary["location"] as? String {
            location = Location(string: locationString)
        }
        startISO8601 = dictionary["start_time"] as? String
        endISO8601 = dictionary["end_time"] as? String
        startTime = startISO8601?.dateFromISO8601
        endTime = endISO8601?.dateFromISO8601
        
        groupSize = dictionary["group_size"] as? Int
        // TODO: init address
//        if let addressDictionary = dictionary["address"] as? NSDictionary {
//            address = Address(dictionary: addressDictionary)
//        }
    }
    
    // store activities rooted by their start date
    func dataKey() -> String {
        if let dateString = startTime?.iso8601.cita_substring(nchars: 10) {
            return "\(Activity.dataRoot)/\(dateString)"
        } else {
            return "unknown-date"
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "full_description": fullDescription,
            "group_size": groupSize,
            "location": location?.toString(),
            "latitude": location?.latitude,
            "longitude": location?.longitude,
            "start_time": startTime?.iso8601,
            "end_time": endTime?.iso8601
        ]
    }
    
    func save() {
        let myRef = FirebaseClient.sharedInstance.ref.child(self.dataKey())
        myRef.childByAutoId().setValue(self.toDictionary())
    }
    
    class func fromDictionaryArray(_ array: [NSDictionary]) -> [Activity] {
        var activities: [Activity] = []
        for dictionary in array {
            let activity = Activity(dictionary: dictionary)
            activities.append(activity)
        }
        return activities
    }
}
