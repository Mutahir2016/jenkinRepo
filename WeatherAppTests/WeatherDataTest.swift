//
//  WeatherDataTest.swift
//  WeatherAppTests
//
//  Created by Mutahir on 07/03/2021.
//

import XCTest
@testable import WeatherApp

class WeatherDataTest: XCTestCase {
    
    func testCanParseWeather() throws {
        let json = """
{"coord":{"lon":55.3047,"lat":25.2582},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}],"base":"stations","main":{"temp":294.59,"feels_like":292.73,"temp_min":294.15,"temp_max":295.15,"pressure":1013,"humidity":64},"visibility":10000,"wind":{"speed":4.63,"deg":270},"clouds":{"all":20},"dt":1615069230,"sys":{"type":1,"id":7537,"country":"AE","sunrise":1615084573,"sunset":1615127022},"timezone":14400,"id":292223,"name":"Dubai","cod":200}
"""
        let jsonData = json.data(using: .utf8)!
        let weatherData = try!JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
        XCTAssertEqual(294.59, weatherData.main.temp)
        XCTAssertEqual("Dubai", weatherData.name)
        XCTAssertEqual(801, weatherData.weather[0].id)
        XCTAssertEqual("few clouds", weatherData.weather[0].weatherDescription)
        
    }
    
    
    func testCanParseWeatherWithEmptyCityName() throws {
        let json = """
{"coord":{"lon":55.3047,"lat":25.2582},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}],"base":"stations","main":{"temp":294.59,"feels_like":292.73,"temp_min":294.15,"temp_max":295.15,"pressure":1013,"humidity":64},"visibility":10000,"wind":{"speed":4.63,"deg":270},"clouds":{"all":20},"dt":1615069230,"sys":{"type":1,"id":7537,"country":"AE","sunrise":1615084573,"sunset":1615127022},"timezone":14400,"id":292223,"name":"","cod":200}
"""
        let jsonData = json.data(using: .utf8)!
        let weatherData = try!JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
        XCTAssertEqual("", weatherData.name)
    }
    
    func testCanReadFromJsonFile() throws {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "cities", ofType: "json") else {
            fatalError("Json file not found")
        }
        print("\n\n\(pathString)\n\n")
        
        guard let json = try? String(contentsOfFile: pathString,encoding: .utf8) else {
            fatalError("Unable to convert json to string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let citiesData = try! JSONDecoder().decode(CityDataModel.self, from: jsonData)
        XCTAssertEqual("Ḩeşār-e Sefīd", citiesData.citiesList![0].name)
    }
}
