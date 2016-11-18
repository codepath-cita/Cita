//
//  Date.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" // "2016-11-19T02:35:41+00:00"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


