//
//  ViewController.swift
//  Clima
//
//  Created by sukhjeet on 01/09/2019.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var navigationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var navigationButtonIsPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" || navigationButtonIsPressed {
            navigationButtonIsPressed = false
            textField.placeholder = "Search"
            textField.endEditing(true)
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            if cityName == "" {
                return
            }
            weatherManager.fetchWeather(cityString: cityName)
        }
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func navigationPressed(_ sender: UIButton) {
        navigationButtonIsPressed = true
        textFieldDidEndEditing(searchTextField)
        searchTextField.endEditing(true)
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = Double(location.coordinate.latitude)
            let lon = Double(location.coordinate.longitude)
            weatherManager.fetchWeather(LONGITUDE: lon, LATITUDE: lat)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
