//
//  SelectedCityDataModel.swift
//  WeatherApp
//
//  Created by Mutahir on 06/03/2021.
//

import Foundation


class SelectedCityDataModel: NSObject {
    var cityId : String
    var cityName : String
    
    init(cityId: String, cityName: String) {
        self.cityId = cityId
        self.cityName = cityName
    }
}
