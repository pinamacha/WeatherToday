//
//  ViewController.swift
//  WeatherToday
//
//  Created by Ravi Pinamacha on 1/19/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GooglePlaces

class WeatherViewController: UIViewController {
    
    var placeName: String = ""

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var sunRise: UILabel!
    @IBOutlet weak var sunSet: UILabel!
    @IBOutlet weak var hiTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    let locationManager =  CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather :  CurrentWeather!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        currentWeather = CurrentWeather()
      viewMore.isHidden = true
       
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

            locationAuthStatus()

    }

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                //ui code to update
                self.updateMainUI()
            }
     
        }else {
            locationManager.requestWhenInUseAuthorization() //get notification
            locationAuthStatus()
        }
        
    }

    @IBAction func viewMore(_ sender: Any) {
      viewMore.isHidden = false
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewMore.isHidden = true
    }
    func updateMainUI(){
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
        sunRise.text = timeforDisplay(unixDateTime: currentWeather.sunrise)
        sunSet.text = timeforDisplay(unixDateTime: currentWeather.sunset)
        wind.text = "\(currentWeather.wind) Mph"
        humidity.text = "\(currentWeather.humidity) %"
        hiTemp.text = "\(currentWeather.hiTemp)"
        lowTemp.text = "\(currentWeather.lowTemp)"
     
        self.get_image("http://openweathermap.org/img/w/" + currentWeather.weatherIcon + ".png", currentWeatherImage)
        
        
    }
    ///for time display 02:30 PM
    func timeforDisplay(unixDateTime : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: unixDateTime)
        
        let dayTimePeriodFormatter = DateFormatter()
        // dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.dateFormat = "hh:mm a "                       //sun 02 jun
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }

    //this  is for retriving image from url and display
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                
                if(image != nil)
                {
                    
                    DispatchQueue.main.async(execute: {
                        
                        imageView.image = image
                        imageView.alpha = 1.0 //alpha is 0 when animate view
                        
                        //                        UIView.animate(withDuration: 1.5, animations: {
                        //                            imageView.alpha = 0.5
                        //                        })
                        
                    })
                    
                }
                
            }
            
            
        })
        
        task.resume()
    }
    
}
