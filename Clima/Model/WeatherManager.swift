//
//  WeatherManager.swift
//  Clima
//
//  Created by sukhjeet on 05/02/21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d3f56cc59719f81e84f70b9050f8b97f&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityString: String) {
        let city = cityString.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString:urlString)
    }
    
    func fetchWeather(LONGITUDE: Double, LATITUDE: Double) {
        let urlString = "\(weatherURL)&lon=\(LONGITUDE)&lat=\(LATITUDE)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedWeatherData.weather[0].id
            let temp = decodedWeatherData.main.temp
            let city = decodedWeatherData.name
            
            let weather = WeatherModel(weatherID: id, cityName: city, temperature: temp)
            return weather
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
