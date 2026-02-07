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
    private var currentLocation: CLLocation?
    var selectedKeyword: Keyword = .cafe
    var places: [PlaceRowModel] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func changeKeyword(to keyword: Keyword) async {
        guard let currentLocation = currentLocation else { return }
        if selectedKeyword == keyword {
            return
        } else {
            selectedKeyword = keyword
        }
        let result = await apiClient.getPlaces(forKeyword: keyword.apiName, location: currentLocation)
        switch result {
        case .success(let placesResponseModel):
            let places = placesResponseModel.results
            self.places = places.compactMap { PlaceRowModel(place: $0) }
        case .failure(let placesError):
            break
        }
    }
    
    func fetchPlaces(location: CLLocation) async {
        print("DEBUG: latitude \(location.coordinate.latitude), longitude \(location.coordinate.longitude)")
        let result = await apiClient.getPlaces(forKeyword: "Coffee", location: location)
        switch result {
        case .success(let placesResponseModel):
            let places = placesResponseModel.results
            self.places = places.compactMap { PlaceRowModel(place: $0) }
        case .failure(let placesError):
            break
        }
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
        currentLocation = location
        Task {
            await fetchPlaces(location: location)
        }
    }
}
