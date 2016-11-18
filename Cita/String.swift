//
//  String.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
    
    func cita_substring(nchars: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: nchars)
        return substring(to: index)
    }
}
