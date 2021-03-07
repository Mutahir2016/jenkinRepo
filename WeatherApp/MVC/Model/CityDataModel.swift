//
//  CityDataModel.swift
//  WeatherApp
//
//  Created by Mutahir on 06/03/2021.
//

import Foundation

// MARK: - CityDataModel
struct CityDataModel: Codable {
    let citiesList: [CitiesList]?

    enum CodingKeys: String, CodingKey {
        case citiesList = "CitiesList"
    }
}

// MARK: - CitiesList
struct CitiesList: Codable {
    let id: Int
    let name, state, country: String
    let coord: Coord
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}
