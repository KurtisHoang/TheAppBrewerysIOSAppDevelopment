//
//  ViewController.swift
//  WeatherApi
//
//  Created by Kurtis Hoang on 4/4/21.
//

import UIKit
import CoreLocation

//UITextFieldDelegate allow class to manage editing validation
class ViewController: UIViewController {

    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    //requires to add a property to plist = Privacy - Location When In Use Usage Description
    //then for the value you need a description of why you need location
    let locationManager = CLLocationManager() //getting current location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        searchTextField.delegate = self //set textField as delegate
        locationManager.delegate = self //for CLLocationManagerDelegate
        
        locationManager.requestWhenInUseAuthorization() //show pop up for user authorization
        locationManager.requestLocation() //request location
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true);
    }
    
    /*
     Below functions come from UITextFieldDelegate
     */
    
    //pressed return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    //triggered when .endEditing(true) is called
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //check if city is valid and trim the text of whitespaces and newlines
        if let city = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
            let replacedCityString = city.replacingOccurrences(of: " ", with: "+") //api for multiple named city ex: San Jose need to be San+Jose, so replacing whitespaces
            weatherManager.fetchWeather(cityName: replacedCityString)
        }
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    //required from WeatherManagerDelegate protocol
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { //Do code in background doesn't wait for dataTask to finish completion in WeatherManager
            self.cityLabel.text = weather.cityName
            self.weatherTemperatureLabel.text = weather.temperatureString
            self.weatherConditionImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //gets called via requestLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            locationManager.stopUpdatingLocation() //stop updating location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
