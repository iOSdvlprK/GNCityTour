//
//  PlacesResponseModel.swift
//  GNCityTour
//
//  Created by joe on 1/28/26.
//

import Foundation

struct PlacesResponseModel: Decodable {
    let results: [PlaceDetailResponseModel]
}

struct PlaceDetailResponseModel: Decodable {
    let placeId: String
    let name: String
    let rating: Double
    let vicinity: String
    let photos: [PhotoInfo]?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name, rating, vicinity, photos
    }
}

struct PhotoInfo: Decodable {
    let photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
