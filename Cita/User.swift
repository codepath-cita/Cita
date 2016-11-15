//
//  User.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    static let currentUserKey = "currentUserData"
    static let userDidLoginNotification = "UserDidLogin"
    static let userDidLogoutNotification = "UserDidLogout"
    static let facebookProfileKeys = ["public_profile", "email", "user_friends"]
    
    var displayName: String?
    var email: String?
    var photoURL: URL?
    var interests = [Tag]()
    
    var facebookDictionary: [String: AnyObject]
    
    init(dictionary: [String: AnyObject]) {
        facebookDictionary = dictionary
        displayName = dictionary["display_name"] as? String
        email = dictionary["email"] as? String
        if let url = dictionary["photo_url"] as? String {
            photoURL = URL(string: url)
        }
    }
    
    init(user: FIRUser) {
        displayName = user.displayName
        email = user.email
        photoURL = user.photoURL
        let photoURLString = photoURL?.absoluteString
        facebookDictionary = [
            "display_name": displayName as AnyObject,
            "email": email as AnyObject,
            "photo_url": photoURLString as AnyObject
        ]
    }
    
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: User.currentUserKey) as? Data {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: AnyObject]
                    let user = User(dictionary: dictionary)
                    _currentUser = user
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.facebookDictionary, options: [])
                
                defaults.set(data, forKey: User.currentUserKey)
            } else {
                defaults.removeObject(forKey: User.currentUserKey)
            }
            defaults.synchronize()
        }
    }
}
