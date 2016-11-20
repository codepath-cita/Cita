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
    var currentFilter: ActivityFilter!
    
    override init() {
        ref = FIRDatabase.database().reference()
        super.init()
    }
    
    func observeActivities(within: LocationFrame?, searchTerm: String?, withinDates dateRange: DateRange = DateRange.thisWeek()) {
        currentFilter = ActivityFilter(dateRange: dateRange, searchTerm: searchTerm, locationFrame: within)
        let activityRef = ref.child(Activity.dataRoot)
        let search = searchTerm ?? "tennis" // FAKE SEARCH TEST
        activityRef.queryStarting(atValue: nil, childKey: dateRange.earliest.iso8601DatePart).queryEnding(atValue: nil, childKey: dateRange.latest.iso8601DatePart).observe(.value, with: { snapshot in
            print("activities for \(snapshot.childrenCount) dates")
            var activities: [NSDictionary] = []
            for child in snapshot.children {
                let activityDateDictionary = (child as! FIRDataSnapshot).value as! NSDictionary
                activityDateDictionary.forEach({ (key: Any, value: Any) in
                    if let activityData = value as? NSDictionary {
                        if within != nil,
                           let locationString = activityData.value(forKey: "location") as? String {
                            // filter on location
                            let location = Location(string: locationString)
                            if !location.inFrame(frame: within!) {
                                print("location not in frame: \(locationString)")
                                return
                            }
                        }
                        if let name = activityData.value(forKey: "name") as? String {
                            // filter on name
                            var match = name.range(of: search)
                            if match == nil,
                               let description = activityData.value(forKey: "full_description") as? String {
                                // filter on description
                                match = description.range(of: search)

                            }
                            if match == nil {
                                print("no search match for name(\(name)) or description(\(activityData.value(forKey: "full_description") as? String))")
                                return
                            }
                        }
                        activityData.setValue(key, forKey: "id")
                        print("activityData=\(activityData)")
                        activities.append(activityData)
                    }
                })
            }
            Activity.currentActivities = Activity.fromDictionaryArray(activities)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Activity.activitiesUpdated), object: nil)
        })
    }
}
