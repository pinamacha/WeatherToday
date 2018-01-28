//
//  Constants.swift
//  WeatherToday
//
//  Created by Ravi Pinamacha on 1/26/18.
//  Copyright © 2018 Divya. All rights reserved.
//


import Foundation

typealias DownloadComplete = () -> () //tell ur function when download complete

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=23ff8f249f7f6e1a17574abdf06c1cc1"
