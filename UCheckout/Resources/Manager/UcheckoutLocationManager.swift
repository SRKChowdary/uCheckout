//
//  UcheckoutLocationManager.swift
//  UCheckout
//
//  Created by i2i Innovation on 14/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
    func locationNotEnabled()
}

class UcheckoutLocationManager: NSObject {
    
    public static  var sharedInstance = UcheckoutLocationManager()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard self.locationManager != nil else {
            return
        }
        
        
    }
    
    func checkLocationStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 20
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager?.requestAlwaysAuthorization()

            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 20
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }else {
            print("unauthorised to use location services")
            delegate?.locationNotEnabled()
        }
    }
    
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
     // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    func calculateDistanceWithCoordinate(_ coordinate₀ : CLLocation , coordinate₁ : CLLocation) -> Double {
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        return distanceInMeters

    }
    
    private func updateLocationDidFailWithError(error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
}
    
}
extension UcheckoutLocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.restricted:
             delegate?.locationNotEnabled()
        case CLAuthorizationStatus.denied:
             delegate?.locationNotEnabled()
        case CLAuthorizationStatus.notDetermined:
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
        //locationStatus = "Status not determined"
        default:
            locationManager?.startUpdatingLocation()
           
        }
        
        
    }
    
   
    
    
}
