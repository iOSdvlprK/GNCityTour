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
    var selectedKeyword: Keyword = .cafe
    
    override init() {
        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchPlaces(location: CLLocation) async {
        print("DEBUG: latitude \(location.coordinate.latitude), longitude \(location.coordinate.longitude)")
        await apiClient.getPlaces(forKeyword: "Coffee", location: location)
    }
}

extension PlacesViewModel: @MainActor CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access has been granted.")
            locationManager.requestLocation()
        case .denied:
            print("Location access has been denied.")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task {
            await fetchPlaces(location: location)
        }
    }
}
