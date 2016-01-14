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
    @IBOutlet weak var tempLal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(weather: futureWeather){
        self.dateLbl.text = weather.date
        self.weatherImg.image = UIImage(named: "\(weather.weatherIconNumber).png")
        self.tempLal.text = weather.tempMax
    }


}
