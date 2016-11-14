//
//  User.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

/*
 id
 first_name
 last_name
 avatar_url
 email
 token
 created_at
 updated_at
*/
class User: NSObject {
    var firstName: String?
    var lastName: String?
    var userName: String?
    var email: String?
    var avatarURL: URL?
    var interests = [Tag]()
    
//    Store the Facebook OAuth token?
//    var token: S
    
    var facebookDictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.facebookDictionary = dictionary
        
        // FIXME: use real FB dictionary key here
        firstName = dictionary["first_name"] as? String
        lastName = dictionary["last_name"] as? String
//        userName = dictionary["user_name"] as? String
        email = dictionary["email"] as? String
        if let url = dictionary["profile_image_url_https"] as? String {
            avatarURL = URL(string: url)
        }
    }
}
