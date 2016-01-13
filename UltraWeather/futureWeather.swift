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
    private var _temp: String!
    
    var date: String{
        return _date
    }
    
    var weatherIconNumber: String{
        return _weatherIconNumber
    }
    
    var temp: String{
        return _temp
    }
    
    init(date:String, weatherIconNumber: String, temp: String) {
        _date = date
        _weatherIconNumber = weatherIconNumber
        _temp = temp
    }
    
}
