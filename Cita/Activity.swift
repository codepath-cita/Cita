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
    
    var id: String?
    var name: String?
    var descriptionString: String?
    var imageURL: URL?
    var location: Location?
    var startTime: Date?
    var endTime: Date?
    var address: Address?
    var createdAt: Date?
    var updatedAt: Date?
    
    static var currentActivities: [Activity]? = []
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        descriptionString = dictionary["description"] as? String
//        if let url = dictionary["image_url"] as? String {
//            imageURL = URL(string: url)
//        }
        if let locationString = dictionary["location"] as? String {
            location = Location(string: locationString)
        }
        let startString = dictionary["start_time"] as! String
        let endString = dictionary["end_time"] as! String
        startTime = startString.dateFromISO8601
        endTime = endString.dateFromISO8601
        // TODO: init address
//        if let addressDictionary = dictionary["address"] as? NSDictionary {
//            address = Address(dictionary: addressDictionary)
//        }
    }
    
    // store activities rooted by their start date
    func dataKey() -> String {
        let dateString = startTime!.iso8601.cita_substring(nchars: 10)
        return "\(Activity.dataRoot)/\(dateString)"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
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
    
    class func fromArray(_ array: [NSDictionary]) -> [Activity] {
        var activities: [Activity] = []
        for dictionary in array {
            let activity = Activity(dictionary: dictionary)
            activities.append(activity)
        }
        return activities
    }
    static var _testActivities: [Activity] = []
    
    class var testActivities: [Activity] {
        get {
            if _testActivities.isEmpty {
                let sf_lat = 37.77
                let sf_long = -122.42
                let startDate = Date(timeIntervalSinceNow: 3*60*60).iso8601
                let endDate = Date(timeIntervalSinceNow: 5*60*60).iso8601
                let dictionaries = [
                    ["id": 1, "name": "Get drinks", "description": "get drinks with me", "latitude": sf_lat, "longitude": sf_long, "start_time": startDate, "end_time": endDate],
                    ["id": 2, "name": "Eat chocolate", "description": "eat chocolate with me and do more stuff that makes this description pretty long.\n\n new lines blah blah\n\n hey guys.", "latitude": sf_lat+0.09, "longitude": sf_long+0.06, "start_time": startDate, "end_time": endDate],
                    ["id": 3, "name": "Play tennis", "description": "play tennis with me", "latitude": sf_lat+0.02, "longitude": sf_long-0.04, "start_time": startDate, "end_time": endDate]
                ]
                for dictionary in dictionaries {
                    _testActivities.append(Activity(dictionary: dictionary as NSDictionary))
                }
            }
            
            return _testActivities
        }
    }
    
    
    
}
