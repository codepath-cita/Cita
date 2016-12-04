//
//  User.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import FirebaseAuth

class User: NSObject {
    static let dbRoot = "users"
    static let currentUserKey = "currentUserData"
    static let userDidLoginNotification = "UserDidLogin"
    static let userDidLogoutNotification = "UserDidLogout"
    static let facebookProfileKeys = ["public_profile", "email", "user_friends"]
    
    var uid: String?
    var providerID: String?
    var displayName: String?
    var email: String?
    var photoURL: URL?
    var interests: [Tag]?
    var activityKeys: [String]?
    var activities: [Activity]?
    var creatorKeys: [String]?
    var lastLogin: String?
    
    init(dictionary: [String: AnyObject]) {
        uid = dictionary["uid"] as? String
        providerID = dictionary["provider_id"] as? String
        displayName = dictionary["display_name"] as? String
        email = dictionary["email"] as? String
        if let url = dictionary["photo_url"] as? String {
            photoURL = URL(string: url)
        }
        activityKeys = dictionary["activity_keys"] as? [String]
        if activityKeys == nil {
            activityKeys = []
        }
        creatorKeys = dictionary["creator_keys"] as? [String]
        if creatorKeys == nil {
            creatorKeys = []
        }
        lastLogin = dictionary["last_login"] as? String
    }
    
    // store users as a large list
    func dataKey() -> String {
        return "\(User.dbRoot)/\(uid!)"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid as Any,
            "provider_id": providerID as Any,
            "display_name": displayName as Any,
            "email": email as Any,
            "photo_url": photoURL?.absoluteString as Any,
            "activity_keys": activityKeys as Any,
            "creator_keys": creatorKeys as Any,
            "last_login": lastLogin as Any
        ]
    }
    
    // save to Firebase DB
    func save() {
        if uid != nil {
            let myRef = FirebaseClient.sharedInstance.ref.child(dataKey())
            print(self.toDictionary())
            myRef.setValue(self.toDictionary())
        }
    }
    
    static var _currentUser: User?
    static var userCache: [String: User] = [:]
    
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
                let data = try! JSONSerialization.data(withJSONObject: user.toDictionary(), options: [])
                defaults.set(data, forKey: User.currentUserKey)
                user.save()
            } else {
                defaults.removeObject(forKey: User.currentUserKey)
            }
            defaults.synchronize()
        }
    }
}
