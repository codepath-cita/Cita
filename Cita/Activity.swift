//
//  Activity.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import CoreLocation
import UIKit
import FirebaseDatabase

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
    static let activitiesUpdated = "activities:updated"
    static let dbRoot = "activities"
    
    let dbRef = FIRDatabase.database().reference(withPath: Activity.dbRoot)
    
    var ref: FIRDatabaseReference?
    var key: String?
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
    var creator: User?
    var attendeeIDs: [String]?
    var attendees: [User]?
    
    static var currentActivities: [Activity]? = []
    
    init(dictionary: NSDictionary) {
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
        attendeeIDs = dictionary["attendee_ids"] as? [String]
        if attendeeIDs == nil {
            attendeeIDs = []
        }
        
        // TODO: init address
        //        if let addressDictionary = dictionary["address"] as? NSDictionary {
        //            address = Address(dictionary: addressDictionary)
        //        }
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        let dictionary = snapshot.value as! NSDictionary
        self.init(dictionary: dictionary)
        key = snapshot.key
        ref = snapshot.ref
    }
    
    // 1. add user to attendee list
    // 2. add activity to user's activity list
    func registerUser(user: User) {
        if let userID = user.uid {
            if user.activityKeys == nil {
                user.activityKeys = []
            }
            if attendeeIDs?.index(of: userID) == nil {
                attendeeIDs?.append(userID)
                save()
            }
            if user.activityKeys?.index(of: userID) == nil {
                let startDate = startTime!.iso8601DatePart
                user.activityKeys?.append("\(startDate)/\(key!)")
                user.save()
            }
        } else {
            print("Error: can't registerUser with nil ID!")
        }
    }
    
    func removeUser(user: User) {
        if let index = attendeeIDs?.index(of: user.uid!) {
            attendeeIDs?.remove(at: index)
            save()
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
            "end_time": endTime?.iso8601,
            "creator_id": creator?.uid,
            "attendee_ids": attendeeIDs
        ]
    }
    
    func save() {
        if ref == nil { // create
            let dateString = startTime!.iso8601.cita_substring(nchars: 10)
            dbRef.child(dateString).childByAutoId().setValue(self.toDictionary())
        } else { // update
            ref!.setValue(self.toDictionary())
        }
    }
    
    class func fromSnapshotArray(_ snapshot: FIRDataSnapshot) -> [Activity] {
        var activities: [Activity] = []
        for child in snapshot.children {
            let dictionary = child as! FIRDataSnapshot
            let activity = Activity(snapshot: dictionary)
            activities.append(activity)
        }
        return activities
    }
}
