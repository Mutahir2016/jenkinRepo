//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Mutahir on 07/03/2021.
//

import Foundation

// MARK: - WeatherDataModel
struct WeatherDataModel: Codable {
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let timezone, id: Int
    let name: String
    let cod: Int
}


// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int
}
