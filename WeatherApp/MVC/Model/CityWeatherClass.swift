//
//  CityWeatherClass.swift
//  WeatherApp
//
//  Created by Mutahir on 05/03/2021.
//

import UIKit

class CityWeatherClass: NSObject {

    var cityID   = 0
    var cityName = ""
     
    
    var weatherDaysInfo = [WeatherDayClass]()
    
    override init() {
        super.init()
    }
    
    init(json:[String:Any])
    {
        super.init()
        
        if let value = json["city"] as? [String:Any]
        {
            cityID = (value["id"] as? NSNumber)?.intValue ?? 0
            cityName = value["name"] as? String ?? ""
        }
        else
        {
            cityName = "Un Known"
        }
        
        if let listInfo = json["list"] as? [[String:Any]]
        {
            for value in listInfo
            {
                let weatherobj = WeatherHourClass(json: value)
                
                
                if weatherDaysInfo.count > 0
                {
                    if let lastValue = weatherDaysInfo.last, self.isSameDay(date1: lastValue.date, date2: weatherobj.date)
                    {
                        lastValue.hoursList.append(weatherobj)
                    }
                    else
                    {
                        let dayobj = WeatherDayClass(json: value)
                        dayobj.hoursList.append(weatherobj)
                        weatherDaysInfo.append(dayobj)
                    }
                }
                else
                {
                    let dayobj = WeatherDayClass(json: value)
                    dayobj.hoursList.append(weatherobj)
                    weatherDaysInfo.append(dayobj)
                }
            }
        }
    }

    func isSameDay(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    
}

class WeatherDayClass: NSObject {
    
    var dateValue : Int64 = 0
    
    var date : Date = Date()
    
    var hoursList = [WeatherHourClass]()
    
    var dateString = ""
    
    override init() {
        //
    }
    
    init(json:[String:Any])
    {
        super.init()
        
        dateValue = (json["dt"] as? NSNumber)?.int64Value ?? 0
        date = Date(timeIntervalSince1970: TimeInterval(dateValue))
        
        dateString = date.dayofTheWeek
    }
    
}

class WeatherHourClass: NSObject {
    //
    var timeValue : Int64 = 0
    var date : Date = Date()
    var hourValue = ""
    var tempValue = ""
    
    override init() {
        super.init()
    }
    
    init(json:[String:Any])
    {
        super.init()
        
        timeValue = (json["dt"] as? NSNumber)?.int64Value ?? 0
        date = Date(timeIntervalSince1970: TimeInterval(timeValue))
        hourValue = getHourValueFrom(date: date)
        
        if let tempInfo = json["main"] as? [String:Any]
        {
            let kelvinTemp = (tempInfo["temp"] as? NSNumber)?.doubleValue ?? 0.0
            let celsiusTemp = kelvinTemp - 273.15
            tempValue = String(format: "%.0f", celsiusTemp)
        }
    }
    
    func getHourValueFrom(date: Date) -> String
    {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: date)
    }
}



extension Date {

        var dayofTheWeek: String {
             let dayNumber = Calendar.current.component(.weekday, from: self)
             // day number starts from 1 but array count from 0
             return daysOfTheWeek[dayNumber - 1]
        }

        private var daysOfTheWeek: [String] {
             return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        }
     }
