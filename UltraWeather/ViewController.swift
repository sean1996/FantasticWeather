//
//  ViewController.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/11/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {

    @IBOutlet weak var weatherTableView:UITableView!
    
    @IBOutlet weak var LocationLbl: UILabel!
    
    @IBOutlet weak var CurrentWeatherImg: UIImageView!
    
    @IBOutlet weak var CurrentTempLbl: UILabel!
    
    @IBOutlet weak var CurrentSunriseLbl: UILabel!
    
    @IBOutlet weak var CurrentSunsetLbl: UILabel!
    
    @IBOutlet weak var CurrentHumidLbl: UILabel!
    
    @IBOutlet weak var CurrentWindLbl: UILabel!
    
    var futureWeatherSet = [futureWeather]()
    
    var currWeather : currentWeather!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse{
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        
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
    //CLLocationManager delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler:
            { (placemarks, error) -> Void in
                if placemarks!.count > 0{
                    let pm = placemarks![0]
                    self.updateWeatherInfo(pm)
                }
        })
    }
    
    
    func updateWeatherInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        currWeather = currentWeather(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude, location: "\(placemark.locality!), \(placemark.administrativeArea!)")
        print(currWeather.location)
        print(currWeather.latitude)
        print(currWeather.longitude)
        
    }
    
    
    //tableview delegate methods
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

