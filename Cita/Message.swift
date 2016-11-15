//
//  Message.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

/*
 id
 text
 user_id
 activity_id
 created_at
 updated_at
 */
class Message: NSObject {
    var id: String?
    var text: String?
    var user: User?
    var activity: Activity?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        text = dictionary["text"] as? String    
    }
}
