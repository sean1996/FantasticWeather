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
    
    let emptyCellWeather = futureWeather(date: "", weatherIconNumber: "",tempMax: "", tempMin:"")
    
    var didDownloadWeatherData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
       self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        didDownloadWeatherData = false
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
    
    //download weather json info and update UI
    func updateWeatherInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        currWeather = currentWeather(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude, location: "\(placemark.locality!), \(placemark.administrativeArea!)")
        currWeather.downLoadCurrentWeatherInfo(){ () -> () in
            //this will be called after download is done
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.LocationLbl.text = currWeather.location
        self.CurrentWeatherImg.image = UIImage(named: currWeather.weatherIconNumber)
        self.CurrentTempLbl.text = currWeather.temp
        self.CurrentHumidLbl.text = currWeather.humid
        self.CurrentWindLbl.text = currWeather.wind
        self.CurrentSunriseLbl.text = currWeather.sunrise
        self.CurrentSunsetLbl.text = currWeather.sunset
        if currWeather.sevenDays.count == 7{
            didDownloadWeatherData = true
        }
        weatherTableView.reloadData()
        print("update")
    }
    
    //tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !didDownloadWeatherData{
            if let cell = weatherTableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell{
                cell.configureCell(emptyCellWeather)
                return cell
            }else{
                let cell = WeatherCell()
                cell.configureCell(emptyCellWeather)
                return cell
                
            }
        }
        
        else{
            let weather = currWeather.sevenDays[indexPath.row]
            if let cell = weatherTableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell{
                cell.configureCell(weather)
                return cell
            }else{
                let cell = WeatherCell()
                cell.configureCell(weather)
                return cell
                
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

