//
//  APIClient.swift
//  GNCityTour
//
//  Created by joe on 1/25/26.
//

import Foundation
import CoreLocation

class APIClient {
    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let googlePlacesKey = apiKey
    
    func getPlaces(forKeyword keyword: String, latitude: Double, longitude: Double) async {
        guard let url = createURL(latitude: latitude, longitude: longitude, keyword: keyword) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
//            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
//            print(json)
            let decodedJSON = try JSONDecoder().decode(PlacesResponseModel.self, from: data)
            print(decodedJSON)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createURL(latitude: Double, longitude: Double, keyword: String) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "rankby", value: "distance"),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "key", value: googlePlacesKey)
        ]
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
