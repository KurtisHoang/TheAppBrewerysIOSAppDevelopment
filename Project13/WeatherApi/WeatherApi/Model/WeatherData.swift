//
//  WeatherData.swift
//  WeatherApi
//
//  Created by Kurtis Hoang on 4/4/21.
//

import Foundation

//Typealias combines two protocols into one
//Codeable = Decodeable and Encodeable
//Decodeable = decode JSON to data
//Encodeable = encode data to JSON
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
