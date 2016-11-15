//
//  Address.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

/*
 street1
 street2
 city
 state
 zip
 country
 created_at
 updated_at
 */
class Address: NSObject {
    var street1: String?
    var street2: String?
    var city: String?
    var state: String?
    var zip: String?
    var country: String?
    
    init(dictionary: NSDictionary) {
        street1 = dictionary["street1"] as? String
        street2 = dictionary["street2"] as? String
        city = dictionary["city"] as? String
        state = dictionary["state"] as? String
        zip = dictionary["zip"] as? String
        country = dictionary["country"] as? String
    }
}
