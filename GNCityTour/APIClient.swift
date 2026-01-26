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
    
    private func createURL(latitude: Double, longitude: Double, keyword: String) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "rankby", value: "distance"),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "key", value: googlePlacesKey)
        ]
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
