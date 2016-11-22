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
    var creator: User?
    var attendeeIDs: [String]?
    var attendees: [User]?
    
    static var currentActivities: [Activity]? = []
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? String
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
    
    func fetchAttendees() {
        if attendeeIDs != nil {
            if self.attendees == nil {
                self.attendees = []
            }
            
            for attendeeID in attendeeIDs! {
                FirebaseClient.sharedInstance.fetchUserByID(userID: attendeeID, success: { (user) in
                    print("EPIC SUCCESS, appending user to activity")
                    self.attendees!.append(user)
                }, failure: {_ in
                    print("EPIC FAIL, I REPEAT EPIC FAILURE to fetch user")
                })
            }
        }
        
        FirebaseClient.sharedInstance.fetchUserByID(userID: dictionary?.value(forKey: "creator_id") as! String, success: { (user) in
            // attach creator here
            self.creator = user
        }, failure: { (error) in
            print("failed to fetch activity creator")
        })
    }
    
    // 1. add user to attendee list
    // 2. add activity to user's activity list
    func registerUser(user: User) {
        if let userID = user.uid {
            if attendeeIDs?.index(of: userID) == nil {
                attendeeIDs?.append(userID)
                save()
            }
            if user.activityIDs?.index(of: userID) == nil {
                user.activities?.append(self)
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
    
    // store activities rooted by their start date
    func dataKey() -> String {
        if let dateString = startTime?.iso8601.cita_substring(nchars: 10) {
            if let key = id {
                return "\(Activity.dataRoot)/\(dateString)/\(key)"
            } else {
                return "\(Activity.dataRoot)/\(dateString)"
            }
            
        } else {
            return "unknown-date/\(self.id)"
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
        let myRef = FirebaseClient.sharedInstance.ref.child(self.dataKey())
        if id == nil { // create
            myRef.childByAutoId().setValue(self.toDictionary())
        } else { // update
            myRef.setValue(self.toDictionary())
        }
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
