//
//  PlacesViewModel.swift
//  GNCityTour
//
//  Created by joe on 1/30/26.
//

import Foundation
import CoreLocation

@MainActor
@Observable
class PlacesViewModel: NSObject {
    private let apiClient = APIClient()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchPlaces() {
        
    }
}

extension PlacesViewModel: @MainActor CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
    }
}
