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
        var activities: [NSDictionary] = []
        activityRef.observe(.value, with: { snapshot in
            print(snapshot.childSnapshot(forPath: "2016-11-19").childrenCount)
            for child in snapshot.childSnapshot(forPath: "2016-11-19").children {
                dump((child as! FIRDataSnapshot).value)
                activities.append((child as! FIRDataSnapshot).value as! NSDictionary)
            }
            Activity.currentActivities = Activity.fromArray(activities)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Activity.activitiesUpdated), object: nil)
        })
    }
}
