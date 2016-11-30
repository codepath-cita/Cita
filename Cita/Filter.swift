//
//  Filter.swift
//  Yelp
//
//  Created by Stephen Chudleigh on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filter: NSObject {
    var searchTerm: String = "Restaurants"
    var categories: [String] = []
    var distance: String = "40000"
    var dateRange: DateRange = DateRange.thisMonth()
    
    func updateWith(filters: [String: AnyObject]) {
        if let categories = filters["categories"] as? [String] {
            self.categories = categories
        }
        
        if let distance = filters["distance"] as? String {
            self.distance = distance
        }

        var fromTime = Date()
        var toTime = DateRange.thisMonth().latest
        
        if filters["from_time"] != nil {
            fromTime = (filters["from_time"] as! String).dateFromISO8601!
        }
        if filters["to_time"] != nil {
            toTime = (filters["to_time"] as! String).dateFromISO8601!
        }
        dateRange = DateRange(earliest: fromTime, latest: toTime)
    }
    
    struct DistanceOption {
        var label: String
        var param: String
    }

    func distanceOptions() -> [DistanceOption] {
        return [DistanceOption(label: "Auto", param: "40000"),
                DistanceOption(label: "0.3 Miles", param: "500"),
                DistanceOption(label: "1 Mile", param: "1610"),
                DistanceOption(label: "5 Miles", param: "8050"),
                DistanceOption(label: "20 Miles", param: "32000")]
    }
    
}
