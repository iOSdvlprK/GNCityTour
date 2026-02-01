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
    
    private func responseType(statusCode: Int) -> ResponseType {
        switch statusCode {
        case 100..<200:
            print("DEBUG: Informational")
            return .informational
        case 200..<300:
            print("DEBUG: OK")
            return .success
        case 300..<400:
            print("DEBUG: Redirection")
            return .redirection
        case 400..<500:
            print("DEBUG: Bad Request")
            return .clientError
        case 500..<600:
            print("DEBUG: Server Error")
            return .serverError
        default:
            return .undefined
        }
    }
    
    func getPlaces(forKeyword keyword: String, latitude: Double, longitude: Double) async {
        guard let url = createURL(latitude: latitude, longitude: longitude, keyword: keyword) else { return }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return
            }
            let responseType = responseType(statusCode: response.statusCode)
            switch responseType {
            case .informational, .redirection, .clientError, .serverError, .undefined:
                print("error in request")
            case .success:
                let decodedJSON = try JSONDecoder().decode(PlacesResponseModel.self, from: data)
                print(decodedJSON)
            }
//            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
//            print(json)
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
