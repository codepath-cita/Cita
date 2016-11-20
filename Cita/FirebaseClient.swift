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
    
    override init() {
        ref = FIRDatabase.database().reference()
        super.init()
    }
    
    func observeActivities(within: LocationFrame?, searchTerm: String?) {
        let activityRef = ref.child(Activity.dataRoot)
        activityRef.observe(.value, with: { snapshot in
            print("activities for \(snapshot.childrenCount) dates")
            var activities: [NSDictionary] = []
            print(snapshot.key)
            for child in snapshot.children {
                let activityDateDictionary = (child as! FIRDataSnapshot).value as! NSDictionary
                activityDateDictionary.forEach({ (key: Any, value: Any) in
                    activities.append(value as! NSDictionary)
                })
            }
            Activity.currentActivities = Activity.fromArray(activities)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Activity.activitiesUpdated), object: nil)
        })
    }
}
