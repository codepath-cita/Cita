//
//  FirebaseClient.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/17/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseClient: NSObject {

    static var sharedInstance = FirebaseClient()

    let ref: FIRDatabaseReference!
    var currentQuery: FIRDatabaseHandle?
    
    override init() {
        ref = FIRDatabase.database().reference()
        super.init()
    }
    
    func observeActivities(filter: Filter) {
        if let query = currentQuery {
            ref.removeObserver(withHandle: query)
        }
        
        // this query filters by start date of activity
        // get all activities that start within date dateRange.earliest...latest
        currentQuery = ref.child(Activity.dbRoot).queryStarting(atValue: nil, childKey: filter.dateRange.earliest.iso8601DatePart).queryEnding(atValue: nil, childKey: filter.dateRange.latest.iso8601DatePart).observe(.value, with: { snapshot in
            print("observing activities for \(snapshot.childrenCount) dates")
            var activities: [Activity] = []
            for child in snapshot.children {
                let date = child as! FIRDataSnapshot
                for dateChild in date.children {
                    let activity = Activity(snapshot: dateChild as! FIRDataSnapshot)
                    
                    if filter.locationFrame != nil { // filter on location
                        if let location = activity.location {
                            if !location.inFrame(frame: filter.locationFrame!) {
                                continue
                            } else {
                                print("location in frame: \(location)")
                            }
                        } else {
                            print("!! no location for activity \(activity.key)")
                            continue
                        }
                    }

                    if !filter.categories.isEmpty {
                        if let category = activity.category {
                            if filter.categories.index(of: category) == nil {
                                print("activity category \(category) not in category search list")
                                continue
                            } else {
                                print("category \(category) in \(filter.categories)")
                            }
                        } else { // nil category does not match list
                            continue
                        }
                    }
                    
                    if let search = filter.searchTerm { // filter on search term
                        let matchName = activity.name?.range(of: search, options: .caseInsensitive)
                        let matchDescription = activity.fullDescription?.range(of: search, options: .caseInsensitive)

                        if matchName==nil && matchDescription==nil {
                            print("no search match for name(\(activity.name)) or description(\(activity.fullDescription))")
                            continue
                        }
                    }
                    print("comparing startTime=\(activity.startTime) to dates \(filter.dateRange.earliest)..\(filter.dateRange.latest)")
                    if activity.startTime! < filter.dateRange.earliest || activity.startTime! > filter.dateRange.latest {
                        print("further filtered date \(activity.startISO8601)")
                        continue
                    }
                    
                    activities.append(activity)
                }
            }
            Activity.currentActivities = activities
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Activity.activitiesUpdated), object: nil)
        })
    }
    
    
    // get data for every user
    func observeUsers() {
        ref.child(User.dbRoot).observe(.value, with: { snapshot in
            print("\(snapshot.childrenCount) users found!")
            for child in snapshot.children {
                if let userDictionary = (child as! FIRDataSnapshot).value as? [String : AnyObject] {
                    print("user data=\(userDictionary)")
                    let uid = userDictionary["uid"] as! String
                    User.userCache[uid] =  User(dictionary: userDictionary)
                }
            }
        })
    }
}
