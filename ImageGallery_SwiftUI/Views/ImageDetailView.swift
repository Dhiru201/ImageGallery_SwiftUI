//
//  ImageDetailView.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import SwiftUI

/// A view that displays the details of a selected image, including navigation for multiple images.
struct ImageDetailView: View {
    @StateObject private var viewModel: ImageDetailViewModel
    
    init(images: [ImageData], currentIndex: Int) {
        _viewModel = StateObject(wrappedValue: ImageDetailViewModel(images: images, currentIndex: currentIndex))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Display the image if it's loaded, otherwise show a progress indicator
                if let uiImage = viewModel.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                } else {
                    ProgressView()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                }
                // Display Other details
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Text("Album ID: \(viewModel.images[viewModel.currentIndex].albumId)")
                            .font(.headline)
                        Text("Image ID: \(viewModel.images[viewModel.currentIndex].id)")
                            .font(.headline)
                    }
                    Text("Title: \(viewModel.images[viewModel.currentIndex].title)")
                        .font(.headline)
                }
                .padding(6)
                
                Spacer()
            }
            // Gesture handling for swiping left and right to navigate images
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        // Only respond to horizontal swipes
                        if abs(value.translation.width) > abs(value.translation.height) {
                            if value.translation.width < 0 {
                                viewModel.moveToNextImage()  // Swipe left to go to the next image
                            } else if value.translation.width > 0 {
                                viewModel.moveToPreviousImage() // Swipe right to go to the previous image
                            }
                        }
                    }
            )
        }
        .background(Color.blue.opacity(0.6))
        .navigationBarTitle(Constants.ImageDetailView.NavigationTitle.rawValue, displayMode: .large)
        .onAppear {
            viewModel.loadCurrentImage() // Load the image for the current index when the view appears
        }
    }
}
