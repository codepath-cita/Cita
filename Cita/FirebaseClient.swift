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
            if let value = snapshot.value as? [NSDictionary] {
                Activity.currentActivities = Activity.fromArray(value)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Activity.activitiesUpdated), object: nil)
            }
        })
    }
}
