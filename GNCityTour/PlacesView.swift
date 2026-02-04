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
                        viewModel.selectedKeyword = keyword
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
            Spacer()
        }
    }
}

#Preview {
    PlacesView()
}
