//
//  ViewController.swift
//  UltraWeather
//
//  Created by Xinghan Wang on 1/11/16.
//  Copyright © 2016 Xinghan Wang. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate  {

    @IBOutlet weak var weatherTableView:UITableView!
    
    @IBOutlet weak var LocationLbl: UILabel!
    
    @IBOutlet weak var CurrentWeatherImg: UIImageView!
    
    @IBOutlet weak var CurrentTempLbl: UILabel!
    
    @IBOutlet weak var CurrentSunriseLbl: UILabel!
    
    @IBOutlet weak var CurrentSunsetLbl: UILabel!
    
    @IBOutlet weak var CurrentHumidLbl: UILabel!
    
    @IBOutlet weak var CurrentWindLbl: UILabel!
    
    
    var disPlayInCelcuis = true
    
    var futureWeatherSet = [futureWeather]()
    
    var currWeather : currentWeather!
    
    let locationManager = CLLocationManager()
    
    let emptyCellWeather = futureWeather(date: "", weatherIconNumber: "",tempMax: "0", tempMin:"0")
    
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
//        if (currWeather != nil){
//            currWeather.downLoadCurrentWeatherInfo(){ () -> () in
//                //this will be called after download is done
//                self.updateUI()
//            }
//        }
//        else{
//             self.locationManager.startUpdatingLocation()
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
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
//        if(disPlayInCelcuis){
//           self.CurrentTempLbl.text = currWeather.temp + " °C"
//        }
//        else{
//            let currentTempInCelcuis = Double(currWeather.temp)
//            self.CurrentTempLbl.text = "\(Int(currentTempInCelcuis! * 1.8 + 32)) °F"
//        }
        self.CurrentHumidLbl.text = currWeather.humid
        self.CurrentWindLbl.text = currWeather.wind
        self.CurrentSunriseLbl.text = currWeather.sunrise
        self.CurrentSunsetLbl.text = currWeather.sunset
        if currWeather.sevenDays.count == 7{
            didDownloadWeatherData = true
        }
        weatherTableView.reloadData()
    }
    
    //tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !didDownloadWeatherData{
            if let cell = weatherTableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell{
                cell.configureCell(emptyCellWeather, DisPlayInCelcuis:disPlayInCelcuis)
                return cell
            }else{
                let cell = WeatherCell()
                cell.configureCell(emptyCellWeather, DisPlayInCelcuis:disPlayInCelcuis)
                return cell
                
            }
        }
        
        else{
            let weather = currWeather.sevenDays[indexPath.row]
            if let cell = weatherTableView.dequeueReusableCellWithIdentifier("WeatherCell") as? WeatherCell{
                cell.configureCell(weather, DisPlayInCelcuis:disPlayInCelcuis)
                return cell
            }else{
                let cell = WeatherCell()
                cell.configureCell(weather, DisPlayInCelcuis:disPlayInCelcuis)
                return cell
                
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    //Three IBActions in the view controller implemented here
    @IBAction func addCityBtnPressed(sender: AnyObject) {
        if (currWeather == nil){
            currWeather = currentWeather(latitude: 0, longitude: 0, location: "Search your city manuallly")
        }
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshButPressed(sender: AnyObject) {
        if (currWeather != nil){
            currWeather.downLoadCurrentWeatherInfo(){ () -> () in
                //this will be called after download is done
                self.updateUI()
            }
        }
        else{
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func ChangeUnit(sender: UIButton) {
        if disPlayInCelcuis{
            disPlayInCelcuis = false
            weatherTableView.reloadData()
            //display the current temperature temp in farenheit
            if(currWeather != nil){
                let currentTempInCelcuis = Double(currWeather.temp)
                self.CurrentTempLbl.text = "\(Int(currentTempInCelcuis! * 1.8 + 32)) °F"
            }
            
        }else{
            disPlayInCelcuis = true
            weatherTableView.reloadData()
            //display the current temperature temp in celcuis
            if(currWeather != nil) {
                self.CurrentTempLbl.text = "\(currWeather.temp) °C"
            }
        }
    }
    
    
    
    //Googleplaces API controller delegates
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithPlace place: GMSPlace!) {
        let  latitudeOfSelectedPlace = place.coordinate.latitude
        let  longitudeOfSelectedPlace = place.coordinate.longitude
        print("latitude:",latitudeOfSelectedPlace)
        print("longtitude:",longitudeOfSelectedPlace)
        let  clLocation = CLLocation(latitude: latitudeOfSelectedPlace, longitude: longitudeOfSelectedPlace)
        CLGeocoder().reverseGeocodeLocation(clLocation, completionHandler:
            { (placemarks, error) -> Void in
                if placemarks!.count > 0{
                    let pm = placemarks![0]
                    if pm.locality == nil{
                        self.currWeather.setLocation("\(pm.administrativeArea!), \(pm.country!)")
                    }else if pm.locality == pm.administrativeArea{  //case for Beijing, Beijing, Shanghai, Shanghai
                        self.currWeather.setLocation("\(pm.administrativeArea!), \(pm.country!)")
                    }else{
                        self.currWeather.setLocation("\(pm.locality!), \(pm.administrativeArea!)")
                    }
                }
        })
        currWeather.set_Latitude(latitudeOfSelectedPlace)
        currWeather.set_Longitude(longitudeOfSelectedPlace)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func viewController(viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: NSError!) {
        print("err!")
        print("Error: ", error.description)
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}



