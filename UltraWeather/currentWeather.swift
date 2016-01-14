//
//  currentWeather.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/13/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import Foundation
import Alamofire

class currentWeather: NSObject{
    private var _location: String
    private var _weatherIconNumber: String
    private var _temp: String
    private var _sunset: String
    private var _sunrise: String
    private var _humid: String
    private var _wind: String
    private var _longitude: Double
    private var _latitude: Double
    private var _sevenDays : [futureWeather]!
    
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
    
    var sevenDays: [futureWeather]{
        return _sevenDays
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
        _sevenDays = [futureWeather]()
    }
    
    func downLoadCurrentWeatherInfo(completed: DownloadComplete){
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(_latitude)&lon=\(_longitude)&APPID=4b087e9e65108afa86ad3938b390e8f7"
        let url = NSURL(string: urlStr)!
        Alamofire.request(.GET, url).responseJSON{ response in
            let result = response.result
            print(result.debugDescription)
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let weatherDict = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    self._weatherIconNumber = weatherDict[0]["icon"] as! String
                    self._weatherIconNumber += "-white.png"
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject>{
                    var temperature = main["temp"] as! Int
                    temperature -= 273
                    self._temp = "\(temperature) °C"
                    self._humid = "\(main["humidity"]!)%"
                }
                if let wind = dict["wind"] as? Dictionary<String, AnyObject>{
                    self._wind = "\(wind["speed"]!)m/s"
                }
                if let sys = dict["sys"] as? Dictionary<String, AnyObject>{
                    let sunsettime = sys["sunset"] as! Double
                    let sunrisetime = sys["sunrise"] as! Double
                    
                    self._sunrise = self.HourtimeFromUnixunixTime(sunrisetime)
                    self._sunset = self.HourtimeFromUnixunixTime(sunsettime)
                    
                }
                let futureUrlStr = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(self._latitude)&lon=\(self._longitude)&cnt=7&APPID=4b087e9e65108afa86ad3938b390e8f7"
                let futureUrl = NSURL(string: futureUrlStr)!
                Alamofire.request(.GET, futureUrl).responseJSON{ response in
                    let futureResult = response.result
                    if let futureDict = futureResult.value as? Dictionary<String, AnyObject>{
                        if let futureWeatherList = futureDict["list"] as? [Dictionary<String, AnyObject>]{
                            for dayDict in futureWeatherList{
                                var tempMax: String!
                                var tempMin: String!
                                if let tempDict = dayDict["temp"] as? Dictionary<String, AnyObject>{
                                    var tempMaxNum = tempDict["max"] as! Int
                                    tempMaxNum = tempMaxNum - 273
                                    tempMax = "\(tempMaxNum)"
                                    
                                    var tempMinNum = tempDict["min"] as! Int
                                    tempMinNum = tempMinNum - 273
                                    tempMin = "\(tempMinNum)"
                                }
                                var futureWeatherIcon: String!
                                if let iconDict = dayDict["weather"] as? [Dictionary<String, AnyObject>]{
                                    futureWeatherIcon = iconDict[0]["icon"] as! String
                                    futureWeatherIcon = futureWeatherIcon + ".png"
                                }
                                var dateString: String!
                                if let unixTime = dayDict["dt"] as? Double{
                                    dateString = self.DatetimeFromUnixunixTime(unixTime)
                                }
                                let oneFutureWeatherDay = futureWeather(date: dateString, weatherIconNumber: futureWeatherIcon, tempMax: tempMax, tempMin: tempMin)
                                self._sevenDays.append(oneFutureWeatherDay)
                            }
                        }
                    }
                    completed()
                }
            }
        }
    }
    
    func HourtimeFromUnixunixTime (unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func DatetimeFromUnixunixTime (unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.stringFromDate(date)
    }

}