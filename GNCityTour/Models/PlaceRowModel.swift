//
//  PlaceRowModel.swift
//  GNCityTour
//
//  Created by joe on 2/5/26.
//

import Foundation

struct PlaceRowModel: Identifiable {
    let id: String
    let name: String
    let photoURL: URL
    let rating: Double
    let address: String
    
    init?(place: PlaceDetailResponseModel) {
        self.id = place.placeId
        self.name = place.name
        self.rating = place.rating
        self.address = place.vicinity
        guard let photos = place.photos,
            let firstPhoto = photos.first,
        let photoURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(firstPhoto.photoReference)&key=\(apiKey)") else {
                return nil
            }
        self.photoURL = photoURL
    }
}
