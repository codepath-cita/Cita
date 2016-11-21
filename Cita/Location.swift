//
//  Location.swift
//  Cita
//
//  Created by Stephen Chudleigh on 11/17/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
    
    init(lat: Double, long: Double) {
        latitude = lat
        longitude = long
    }
    
    init(string: String) {
        let latLong = string.characters.split(separator:",")
        let lat = String(latLong[0])
        let long = String(latLong[1])
        latitude = Double(lat)!
        longitude = Double(long)!
    }
    
    func toString() -> String {
        return "\(latitude),\(longitude)"
    }
    
    func inFrame(frame: LocationFrame) -> Bool {       
        return (
            (frame.lowerLeft.latitude...frame.upperRight.latitude ~= latitude) &&
            (frame.lowerLeft.longitude...frame.upperRight.longitude ~= longitude)
        )
    }
}

struct LocationFrame {
    let lowerLeft: Location
    let upperRight: Location
}
