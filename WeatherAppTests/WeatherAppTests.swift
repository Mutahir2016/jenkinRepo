//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Mutahir on 07/03/2021.
//

import XCTest
@testable import WeatherApp
class WeatherAppTests: XCTestCase {
    
    var sut: LocationManager!
    
    override func tearDown() {
        sut = nil
    }
    
    func testWeatherAPIWorking(){
            
            let expectation = XCTestExpectation.init(description: "API response ok")
            let city = SelectedCityDataModel(cityId: "292223", cityName: "Dubai")
            
            let api = String(format: ApiManager.weatherInfoByCityId, city.cityId)
            ApiManager.requestFromServerFor(callName: api, apiMethod: .GET, parameter: [:]) { (bSuccess, response, error) in
                //Fetch response
                if bSuccess
                {
                    expectation.fulfill()
                } else {
                    XCTFail(error)
                }
            }
            
        }
        
        func testWeatherAPIResponseParsingWorking(){
            
            let expectation = XCTestExpectation.init(description: "Response parsed successfully")
            let city = SelectedCityDataModel(cityId: "292223", cityName: "Dubai")
            
            let api = String(format: ApiManager.weatherInfoByCityId, city.cityId)
            ApiManager.requestFromServerFor(callName: api, apiMethod: .GET, parameter: [:]) { (bSuccess, response, error) in
                //Fetch response
                if bSuccess
                {
                    do {
                        // here "jsonData" is the dictionary encoded in JSON data
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        _ = try JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
                        expectation.fulfill()
                    } catch {
                        XCTFail("API response couldn't be parsed, error: \(error.localizedDescription)")
                    }
                } else {
                    XCTFail("API response was not successful, error: \(error)")
                }

            }
            
        }
}
