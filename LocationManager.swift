//
//  LocationManager.swift
//  Wazzee
//
//  Created by Christoph Blessing on 17.01.21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    var oldLocation: CLLocation? = nil
    var newLocation: CLLocation? = nil
    @Published var totalDistance: Double = 0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop(){
        locationManager.stopUpdatingLocation()
    }
    
    func reset(){
        stop()
        totalDistance = 0
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        oldLocation = newLocation
        newLocation = locations.last
        
        if ((oldLocation == nil || newLocation == nil || oldLocation == newLocation)){
            return
        }
        
        let distance: CLLocationDistance = oldLocation!.distance(from: newLocation!)
        
        oldLocation = newLocation
        
        self.totalDistance += distance
    }
}
