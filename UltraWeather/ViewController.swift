//
//  ViewController.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/11/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var weatherTableView:UITableView!
    
    var futureWeatherSet = [futureWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        let w1 = futureWeather(date: "Jan 01", weatherIconNumber: "01n",temp: "32C")
        let w2 = futureWeather(date: "Jan 02", weatherIconNumber: "01n",temp: "32C")
        let w3 = futureWeather(date: "Jan 03", weatherIconNumber: "01n",temp: "32C")
        let w4 = futureWeather(date: "Jan 04", weatherIconNumber: "01n",temp: "32C")
        let w5 = futureWeather(date: "Jan 05", weatherIconNumber: "01n",temp: "32C")
        futureWeatherSet.append(w1)
        futureWeatherSet.append(w2)
        futureWeatherSet.append(w3)
        futureWeatherSet.append(w4)
        futureWeatherSet.append(w5)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let weather = futureWeatherSet[indexPath.row]
        if let cell = weatherTableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell{
            cell.configureCell(weather)
            return cell
        }else{
            let cell = WeatherCell()
            cell.configureCell(weather)
            return cell

        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }



}

