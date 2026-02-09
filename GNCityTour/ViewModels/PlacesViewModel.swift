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
    var isLoading = false
    var alertTitle = ""
    var alertMessage = ""
    var presentAlert = false
    
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
        isLoading = true
        let result = await apiClient.getPlaces(forKeyword: keyword.apiName, location: currentLocation)
        isLoading = false
        parseAPI(result: result)
    }
    
    func fetchPlaces(location: CLLocation) async {
        isLoading = true
        let result = await apiClient.getPlaces(forKeyword: "Coffee", location: location)
        isLoading = false
        parseAPI(result: result)
    }
    
    private func parseAPI(result: APIClient.PlacesResult) {
        switch result {
        case .success(let placesResponseModel):
            let places = placesResponseModel.results
            self.places = places.compactMap { PlaceRowModel(place: $0) }
        case .failure(let placesError):
            switch placesError {
            case .invalidURL, .invalidResponse, .badRequestError:
                alertTitle = "Something Has Gone Wrong"
                alertMessage = "We apologize and we are looking into the issue. Please try again later."
            case .serverError:
                alertTitle = "Something Has Gone Wrong"
                alertMessage = "Please check your internet connection or please try again later."
            }
            presentAlert = true
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
