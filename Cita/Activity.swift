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
    var userActivityKey: String { // requires a startTime and key!
        return "\(startTime!.iso8601DatePart)/\(key!)"
    }
    var name: String?
    var category: String?
    var fullDescription: String?
    var groupSize: Int?
    var imageURL: URL?
    var location: Location?
    var startISO8601: String?
    var endISO8601: String?
    var startTime: Date?
    var endTime: Date?
    var countdownDuration: Double?
    var address: String?
    var createdAt: Date?
    var updatedAt: Date?
    var creatorID: String?
    var creator: User?
    var attendeeIDs: [String]?
    var attendeeCount: Int {
        return (attendeeIDs?.count ?? 0) + 1 // include the creator in the count
    }
    var attendees: [User]?
    var owner: Bool = false
    
    static var currentActivities: [Activity]? = []

    static var other = "Random/Other"
    static var categoryIcons: [String:UIImage] = [
        "Sports": #imageLiteral(resourceName: "sports-ball"),
        "Exercise": #imageLiteral(resourceName: "workout"),
        "Games": #imageLiteral(resourceName: "games"),
        "Drinks": #imageLiteral(resourceName: "drinks"),
        "Food": #imageLiteral(resourceName: "food"),
        "Music": #imageLiteral(resourceName: "music"),
        "Dancing": #imageLiteral(resourceName: "dance"),
        "Outdoors": #imageLiteral(resourceName: "outdoors"),
        "Family": #imageLiteral(resourceName: "family"),
        "Discussion": #imageLiteral(resourceName: "discussion"),
        "Sightseeing": #imageLiteral(resourceName: "sightseeing"),
        "Political": #imageLiteral(resourceName: "politics"),
        "Volunteer": #imageLiteral(resourceName: "volunteer"),
        "Religious": #imageLiteral(resourceName: "religion"),
        Activity.other: #imageLiteral(resourceName: "other")
    ]

    static var categoryMarkers: [String:UIImage] = [
        "Sports": #imageLiteral(resourceName: "marker_sports"),
        "Exercise": #imageLiteral(resourceName: "marker_workout"),
        "Games": #imageLiteral(resourceName: "marker_games"),
        "Drinks": #imageLiteral(resourceName: "marker_drinks"),
        "Food": #imageLiteral(resourceName: "marker_food"),
        "Music": #imageLiteral(resourceName: "marker_music"),
        "Dancing": #imageLiteral(resourceName: "marker_dance"),
        "Outdoors": #imageLiteral(resourceName: "marker_outdoors"),
        "Family": #imageLiteral(resourceName: "marker_family"),
        "Discussion": #imageLiteral(resourceName: "marker_discussion"),
        "Sightseeing": #imageLiteral(resourceName: "marker_sightseeing"),
        "Political": #imageLiteral(resourceName: "marker_politics"),
        "Volunteer": #imageLiteral(resourceName: "marker_volunteer"),
        "Religious": #imageLiteral(resourceName: "marker_religion"),
        Activity.other: #imageLiteral(resourceName: "marker_other")
    ]
    
    static var categoryNames: [String] = Activity.categoryIcons.keys.sorted()
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        category = dictionary["category"] as? String
        fullDescription = dictionary["full_description"] as? String
        
        if let locationString = dictionary["location"] as? String {
            location = Location(string: locationString)
        }
        startISO8601 = dictionary["start_time"] as? String
        endISO8601 = dictionary["end_time"] as? String
        startTime = startISO8601?.dateFromISO8601
        endTime = endISO8601?.dateFromISO8601
        countdownDuration = dictionary["duration"] as? Double
        
        address = dictionary["address"] as? String
        groupSize = dictionary["group_size"] as? Int
        creatorID = dictionary["creator_id"] as? String
        attendeeIDs = dictionary["attendee_ids"] as? [String]
        if attendeeIDs == nil {
            attendeeIDs = []
        }
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
        guard let userID = user.uid else {
            print("Error: can't registerUser with nil ID!")
            return
        }
        guard startTime != nil, key != nil else {
                print("Error: invalid activity missing start time or key: \(name)")
                return
        }

        self.attendeeIDs!.append(userID)
        save()

        user.activityKeys!.append(userActivityKey)
        user.interests?.insert(category!)
        user.save()
        
        FirebaseClient.sharedInstance.notifyActivityCreator(activity: self)
    }
    
    func removeUser(user: User) {
        guard let userID = user.uid else {
            print("Error: can't removeUser with nil ID!")
            return
        }
        guard startTime != nil, key != nil else {
            print("Error: invalid activity missing start time  or key: \(name)")
                return
        }
        
        if let index = attendeeIDs?.index(of: userID) {
            attendeeIDs?.remove(at: index)
            save()
        }
        
        if let index = user.activityKeys?.index(of: userActivityKey) {
            if let intex = user.interests?.index(of: category!) {
                user.interests?.remove(at: intex)
            }
            user.activityKeys?.remove(at: index)
            user.save()
        }
    }
    
    func isRegistrationFull() -> Bool {
        guard attendeeIDs != nil else {
            print("no attendees for \(key)")
            return false
        }
        
        // number attending incl. the creator
        return attendeeIDs!.count + 1 >= groupSize!
    }
    
    func attendeeCountText() -> String {
        return "\(attendeeCount) of \(groupSize ?? -1) spots taken"
    }
    
    func durationText() -> String {
        if let duration = countdownDuration {
            return Activity.durationText(duration)
        }
        return ""
    }
    
    func iconImage() -> UIImage? {
        if let category = category {
            return Activity.categoryIcons[category]
        } else {
            return Activity.categoryIcons[Activity.other]
        }
    }
    
    func iconMarker() -> UIImage? {
        if let category = category {
            return Activity.categoryMarkers[category]
        } else {
            return Activity.categoryMarkers[Activity.other]
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name as Any,
            "category": category as Any,
            "full_description": fullDescription as Any,
            "group_size": groupSize as Any,
            "location": location?.toString() as Any,
            "latitude": location?.latitude as Any,
            "longitude": location?.longitude as Any,
            "start_time": startTime?.iso8601 as Any,
            "end_time": endTime?.iso8601 as Any,
            "duration": countdownDuration as Any,
            "creator_id": creator?.uid as Any,
            "attendee_ids": attendeeIDs as Any,
            "address" : address as Any
        ]
    }
    
    func save() {
        if ref == nil { // create
            let dateString = startTime!.iso8601.cita_substring(nchars: 10)
            let firDatabaseRef = dbRef.child(dateString).childByAutoId()
            firDatabaseRef.setValue(self.toDictionary())
            self.key = firDatabaseRef.key
            
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
    
    class func durationText(_ duration: Double) -> String {
        let minutes = Int((duration / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(floor(duration / 3600))
        
        var durationText = ""
        if hours > 0 {
            durationText.append("\(hours) hours ")
        }
        if minutes > 0 {
            durationText.append("\(minutes) minutes")
        }
        return durationText
    }
}
