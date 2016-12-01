//
//  Date.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation
import SwiftDate

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
    var iso8601DatePart: String {
        return Formatter.iso8601.string(from: self).cita_substring(nchars: 10)
    }
    
    func cita_withinRange(dates: DateRange) -> Bool {
        return self.compare(dates.earliest) == .orderedAscending && self.compare(dates.latest) == .orderedDescending
    }
    
    static func niceToRead(from: Date, to: Date, terse: Bool) -> String {
        let now = Date(timeIntervalSinceNow: 0)
        
        if now.year == from.year {
            
        }
        let zero = from.string(format: .custom("MMM d"))
        let one = from.string(format: .custom("h:mm"))
        let two = to.string(format: .custom("h:mm a"))
        if !terse {
            return  zero + " from " + one + " to " + two
        } else {
            return  zero + ", " + one + " - " + two
        }
    }
    
}

struct DateRange {
    static let secondsInDay = 24*60*60
    let earliest: Date
    let latest: Date
    
    static func today() -> DateRange {
        let latest = Date(timeIntervalSinceNow: TimeInterval(secondsInDay)) // 24 hrs
        return DateRange(earliest: Date(), latest: latest)
    }
    
    static func thisWeek() -> DateRange {
        let latest = Date(timeIntervalSinceNow: TimeInterval(7*secondsInDay))
        return DateRange(earliest: Date(), latest: latest)
    }
    
    static func thisMonth() -> DateRange {
        let latest = Date(timeIntervalSinceNow: TimeInterval(31*secondsInDay))
        return DateRange(earliest: Date(), latest: latest)
    }
}


