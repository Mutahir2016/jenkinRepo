//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Mutahir on 06/03/2021.
//

import UIKit
import Alamofire

class ApiManager: NSObject {
    
    static let apiBaseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    static let API_KEY = "d38be1dd9f91e619ccced2132fb8ec36"
    //api links
    static let weatherInfoByCityId = apiBaseUrl + "id=%@&appid=\(API_KEY)"// city id
    static let weatherInfoByCityName = apiBaseUrl + "q=%@,%@&appid=\(API_KEY)"// city name, state code
    
    static let api5DaysBaseUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    
    //api links
    static let weatherInfo5DaysByCityId = api5DaysBaseUrl + "q=%@&appid=\(API_KEY)"// city id
    static let weatherInfo5DaysByCityName = api5DaysBaseUrl + "q=%@,%@&appid=\(API_KEY)"// city name, state code
    
    //MARK: ****** HTTP Methods ******
    enum HTTP_Method : String {
        case GET     = "GET"
        case POST    = "POST"
        case PUT     = "PUT"
        case PATCH   = "PATCH"
        case DELETE  = "DELETE"
    }
    
    //MARK: API Calling method
    static func requestFromServerFor(callName:String, apiMethod:HTTP_Method, parameter:Parameters, completionHandler:@escaping (_ result : Bool, _ requestData:[String:Any], _ errorMessage:String)-> Void) {
        if let requestURL = URL(string: callName) {
            if Connectivity.isConnectedToInternet {
                AF.request(requestURL, method: HTTPMethod(rawValue: apiMethod.rawValue),
                           parameters: parameter).responseJSON { (response) in
                            // check the status code (200    Success.)
                            if response.response?.statusCode == 200 {
                                if let res = response.value as? [String : Any]
                                {
                                    completionHandler(true, res, "");
                                }
                                else if let res = response.value as? [[String:Any]]
                                {
                                    let data : [String:Any] = ["data": res]
                                    completionHandler(true, data, "");
                                }
                                else
                                {
                                    completionHandler(false, [:], "response not valid");
                                }
                            }
                            else if response.response?.statusCode == 204
                            {
                                completionHandler(true, [:], "success without response");
                            }
                            else if response.response != nil// get respose code and check with error list
                            {
                                print("\(String(describing: response.value))")
                                
                                if let errorInfo = response.value as? [String : Any]
                                {
                                    var message = ""
                                    if let errors = errorInfo["errors"] as? [[String:Any]]
                                    {
                                        for errorValue in errors
                                        {
                                            message = message + (errorValue["msg"] as? String ?? errorValue.description) + "\n"
                                        }
                                    }
                                    else if let errorValue = errorInfo["errors"] as? [String:Any]
                                    {
                                        message = message + (errorValue["msg"] as? String ?? errorValue.description)
                                    }
                                    else
                                    {
                                        message = errorInfo.description
                                    }
                                    
                                    completionHandler(false, [:], String(describing: message));
                                }
                                else
                                {
                                    completionHandler(false, [:], String(describing: response.value));
                                }
                            }
                            else if let error = response.error
                            {
                                completionHandler(false, [:], String(describing: error.localizedDescription));
                            }
                            else
                            {
                                completionHandler(false, [:], String(describing: response.value));
                            }
                           }
            }
            else
            {
                completionHandler(false, [:], "Check your internet Connection and try Again");
            }
        }
        else
        {
            completionHandler(false, [:], "invalid url");
        }
    }
}

// check internet connection
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

