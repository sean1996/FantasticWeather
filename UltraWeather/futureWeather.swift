//
//  futureWeather.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/13/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import Foundation

class futureWeather: NSObject{
    private var _date: String!
    private var _weatherIconNumber: String!
    private var _tempMax: String!
    private var _tempMin: String!
    
    var date: String{
        return _date
    }
    
    var weatherIconNumber: String{
        return _weatherIconNumber
    }
    
    var tempMax: String{
        return _tempMax
    }
    
    var tempMin: String{
        return _tempMin
    }
    
    init(date:String, weatherIconNumber: String, tempMax: String, tempMin: String) {
        _date = date
        _weatherIconNumber = weatherIconNumber
        _tempMax = tempMax
        _tempMin = tempMin
    }
    func printInfo(){
        print(_date)
        print(_weatherIconNumber)
        print(_tempMax)
        print(_tempMin)
    }
    
}
