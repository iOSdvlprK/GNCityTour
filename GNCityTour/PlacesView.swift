//
//  PlacesView.swift
//  GNCityTour
//
//  Created by joe on 1/24/26.
//

import SwiftUI

struct PlacesView: View {
    let apiClient = APIClient()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task {
            await apiClient.getPlaces(forKeyword: "Coffee", latitude: 40.741895, longitude: -73.989308)
        }
    }
}

#Preview {
    PlacesView()
}
