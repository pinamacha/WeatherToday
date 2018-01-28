//
//  CurrentLocationViewController.swift
//  WeatherToday
//
//  Created by Ravi Pinamacha on 1/26/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit
import Alamofire


class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: String!
    var _wind: Double!
    var _humidity: Int!
    var _sunrise:Double!
    var _sunset:Double!
    var _hiTemp: String!
    var _lowTemp: String!
    var _weatherIcon: String!
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "0 °C"
        }
        return _currentTemp
    }
    var hiTemp: String {
        if _hiTemp == nil {
            _hiTemp = "0 °C"
        }
        return _hiTemp
    }
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = "0 °C"
        }
        return _lowTemp
    }
    var wind: Double {
        if _wind == nil {
            _wind = 0.0
        }
        return _wind
    }
    var humidity: Int {
        if _humidity == nil {
            _humidity = 0
        }
        return _humidity
    }
    var sunrise: Double {
        if _sunrise == nil {
            _sunrise = 0.0
        }
        return _sunrise
    }
    
    var sunset: Double {
        if _sunset == nil {
            _sunset = 0.0
        }
        return _sunset
    }
    
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Alamofire download current weather
        //        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON(completionHandler: { response in
            let  result = response.result
            if let dict = result.value  as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                    if  let weatherIcon = weather[0]["icon"] as? String {
                        self._weatherIcon = weatherIcon
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemprature = main ["temp"] as? Double {
                        let kelvinToFarenHeit = String(format: "%.0f °C", currentTemprature - 273.15)
                        self._currentTemp = kelvinToFarenHeit
                        print(self._currentTemp)
                    }
                    if let lowTemp = main["temp_min"]  as? Double {
                        let kelvinToFarenHeit = String(format: "%.0f °C", lowTemp - 273.15)
                        self._lowTemp = kelvinToFarenHeit
                    }
                    if let hiTemp = main["temp_max"]  as? Double  {
                        let kelvinToFarenHeit = String(format: "%.0f °C", hiTemp - 273.15)
                        self._hiTemp = kelvinToFarenHeit
                    }
                    if let humidity = main["humidity"] as? Int {
                        self._humidity = humidity
                    }
                }
                if let sys = dict["sys"] as? Dictionary<String, AnyObject> {
                    if let sunrise = sys["sunrise"] as? Double {
                        self._sunrise = sunrise
                    }
                    if let sunset = sys["sunset"] as? Double {
                        self._sunset = sunset
                    }
                }
                if let wind = dict["wind"] as? Dictionary<String, AnyObject> {
                    if let  windSpeed = wind["speed"] as? Double {
                        self._wind = windSpeed
                    }
                }
            }

            completed()
            
            
        })
        
        
    }
    
    
}
