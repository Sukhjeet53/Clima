//
//  WeatherData.swift
//  Clima
//
//  Created by sukhjeet on 06/02/21.
//

import Foundation

struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
}
