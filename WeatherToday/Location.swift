//
//  Location.swift
//  WeatherToday
//
//  Created by Ravi Pinamacha on 1/26/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import Foundation
class Location {
    static var sharedInstance = Location()
    private init(){}
    var latitude: Double!
    var longitude: Double!
}

