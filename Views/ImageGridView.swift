//
//  ImageGridView.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import SwiftUI

/// A view that displays a grid of images.
struct ImageGridView: View {
    @StateObject private var viewModel = ImageGridViewModel()
  
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: viewModel.spacing) {
                    ForEach(Array(viewModel.images.enumerated()), id: \.element.id) { index, image in
                        // Navigation link to the detail view for each image
                        NavigationLink(destination: ImageDetailView(images: viewModel.images, currentIndex: index)) {
                            GridView(urlString: image.thumbnailUrl)
                        }
                    }
                }
                .padding(viewModel.spacing) // Padding around the grid
            }
            .background(Color.blue.opacity(0.3))
            .navigationBarTitle(Constants.ImageGridView.NavigationTitle.rawValue , displayMode: .large)
            .onAppear {
                // Fetch images only if the image array is empty
                if viewModel.images.isEmpty {
                    viewModel.fetchImages()
                }
            }
        }
    }
}
