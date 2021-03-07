//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Mutahir on 06/03/2021.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    /**************************************************/
    //MARK: Declarations.
    /**************************************************/
    
    // Swifty way of creating a singleton
    static let shared = LocationManager()
    
    // set the manager object right when it gets initialized
    let manager: CLLocationManager = {
        
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.distanceFilter  = 50
        $0.startUpdatingLocation()
        $0.pausesLocationUpdatesAutomatically = false
        //$0.requestWhenInUseAuthorization()
        
        return $0
    }(CLLocationManager())
    
    var currentLocation: CLLocation? = nil
    var currentHeading: CLHeading!
    
    var currentLocInfo : ReversedGeoLocation!
    
    var authorizationChangeHandler : ((CLAuthorizationStatus)->Void)?
    
     override init() {
        super.init()
        // delegate MUST be set while initialization
        manager.delegate = self
    }
    
    func requestUserPermissionsAndStartUpdatingLocation()
    {
        self.manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    /**************************************************/
    // MARK: Control Mechanisms
    /**************************************************/
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    /**************************************************/
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    /**************************************************/
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    /**************************************************/
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    /**************************************************/
    // MARK: Location Updates
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        // If location data can be determined
        if let location = locations.last, currentLocation == nil
        {
            currentLocation = location
            self.stopUpdatingLocation()
            //            NotificationCenter.default.post(name: .didReceiveLocation, object: currentLocation)
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(currentLocation!, completionHandler:
                                        {(placemarks, error) in
                                            if (error != nil)
                                            {
                                                print("reverse geodcode fail: \(error!.localizedDescription)")
                                            }
                                            let pm = placemarks! as [CLPlacemark]
                                            
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                self.currentLocInfo = ReversedGeoLocation(with: pm)
                                            }
                                        })
        }
    }
    
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print("Location Manager Error: \(error)")
    }
    
    /**************************************************/
    // TAK: Task 165 App permissions in dashboard
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationChangeHandler?(status)
    }
    
    /**************************************************/
    // MARK: Heading Updates
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateHeading newHeading: CLHeading)
    {
        currentHeading = newHeading
    }
    
    /**************************************************/
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    /**************************************************/
    
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}


