//
//  Tag.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

/*
 text
 autocomplete
 created_at
 */
class Tag: NSObject {

    var text: String?
    var autocomplete: Bool = false
    
    init(text: String, autocomplete: Bool = false) {
        self.text = text
        self.autocomplete = autocomplete
    }
}
