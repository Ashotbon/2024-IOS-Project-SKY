//
//  LocationManager.swift
//  2024-IOS-Project-SKY
//
//  Created by Ashot Harutyunyan on 2024-04-03.
//

import CoreLocation



// LocationManager should be a class that inherits from NSObject
// and conforms to ObservableObject and CLLocationManagerDelegate
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject{
    private var locationManager: CLLocationManager?
    @Published var currentLocation: CLLocation? // Use @Published so changes will update the view

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }


    func start() {
        locationManager?.startUpdatingLocation()
    }
    
    func requestPermission() {
        if let manager = locationManager {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location // This will now trigger view updates
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }
}

