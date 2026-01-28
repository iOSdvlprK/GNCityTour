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
    let place_id: String
    let name: String
    let rating: Double
    let vicinity: String
    let photos: [PhotoInfo]?
}

struct PhotoInfo: Decodable {
    let photo_reference: String
}
