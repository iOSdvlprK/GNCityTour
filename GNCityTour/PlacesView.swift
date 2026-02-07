//
//  PlacesView.swift
//  GNCityTour
//
//  Created by joe on 1/24/26.
//

import SwiftUI

struct PlacesView: View {
    @State private var viewModel = PlacesViewModel()
    
    private var HorizontalList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(Keyword.allCases) { keyword in
                    Button(action: {
                        Task {
                            await viewModel.changeKeyword(to: keyword)
                        }
                    }, label: {
                        Text(keyword.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(viewModel.selectedKeyword == keyword ? .gray : .black)
                            .padding(.horizontal, 10)
                    })
                    .scaleEffect(viewModel.selectedKeyword == keyword ? 0.85 : 1)
                }
            }
            .frame(height: 50)
        }
    }
    
    var body: some View {
        VStack {
            HorizontalList
            List {
                ForEach(viewModel.places) { place in
                    HStack {
                        AsyncImage(url: place.photoURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.system(size: 15, weight: .semibold))
                            Text(place.address)
                                .font(.system(size: 14))
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("\(Int(place.rating))")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    PlacesView()
}
