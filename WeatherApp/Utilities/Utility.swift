//
//  Utility.swift
//  WeatherApp
//
//  Created by Mutahir on 05/03/2021.
//

import Foundation
import UIKit

var sv: UIView? = nil
extension UIViewController {
    
    func getCitiesData() -> [CitiesList]?
    {
        var cityListArr : [CitiesList]? = []

        if let path = Bundle.main.path(forResource: "citylist", ofType: "json") {
            
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let citiesObj = try JSONDecoder().decode(CityDataModel.self, from: jsonData)
                cityListArr = citiesObj.citiesList
                
                if cityListArr!.count > 0 {
                    return cityListArr
                }
            } catch let myError {
                print("caught: \(myError)")
            }
        }
        return cityListArr
    }
    
    
    /// This function displays spinner by getting UIView object as perimeter
    ///
    /// - Parameter onView: View on which spinner is shown
    class func displaySpinner(onView : UIView) {
        sv = UIView.init(frame: onView.bounds)
        sv?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = (sv?.center)!
        
        DispatchQueue.main.async {
            sv?.addSubview(ai)
            onView.addSubview(sv!)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    /// This function removes spinner
    class func removeSpinner() {
        DispatchQueue.main.async {
            sv?.removeFromSuperview()
        }
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    /// This function displays Alert message with String passed through parameter with Ok action button
    /// - Parameter messageToDisplay: String message to be displayed on Alert.
    func displayAlertMessageWith(title:String,messageToDisplay: String)
    {
        let alertController = UIAlertController(title: title, message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayAlertMessage(title:String,messageToDisplay: String)
    {
        let alertController = UIAlertController(title: title, message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }

}
