//
//  WeatherCell.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/13/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var MinTempLbl: UILabel!
    @IBOutlet weak var MaxTempLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(weather: futureWeather, DisPlayInCelcuis: Bool){
        self.dateLbl.text = weather.date
        self.weatherImg.image = UIImage(named: weather.weatherIconNumber)
        if DisPlayInCelcuis{
            self.MinTempLbl.text = weather.tempMin
            self.MaxTempLbl.text = weather.tempMax
        }
        else{
            let minTempCelcuis = Double(weather.tempMin)
            let maxTempCelcuis = Double(weather.tempMax)
            //display weather in farenheit
            self.MinTempLbl.text = "\(Int(minTempCelcuis! * 1.8 + 32))"
            self.MaxTempLbl.text = "\(Int(maxTempCelcuis! * 1.8 + 32))"
        }
    }
}
