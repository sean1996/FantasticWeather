//
//  currentWeather.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/13/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import Foundation

class currentWeather: NSObject{
    private var _location: String
    private var _weatherIconNumber: String
    private var _temp: String
    private var _sunset: String
    private var _sunrise: String
    private var _humid: String
    private var _wind: String
    private var _longitude: Double!
    private var _latitude: Double!
    
    var location: String{
        return _location
    }
    
    var weatherIconNumber: String{
        return _weatherIconNumber
    }
    
    var temp: String{
        return _temp
    }
    
    var sunset: String{
        return _sunset
    }
    
    var sunrise: String{
        return _sunrise
    }
    
    var humid: String{
        return _humid
    }
    
    var wind: String{
        return _wind
    }
    
    var longitude: Double {
        return _longitude
    }
    
    var latitude: Double {
        return _latitude
    }
    
    
    
    init(latitude: Double, longitude:Double, location: String) {
        _weatherIconNumber = ""
        _temp = ""
        _sunset = ""
        _sunrise = ""
        _humid = ""
        _wind = ""
        _location = location
        _latitude = latitude
        _longitude = longitude
    }
    
}