//
//  ImageDetailViewModel.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import Foundation
import SwiftUI
import Combine

/// A view model for managing image details and navigation logic.
class ImageDetailViewModel: ObservableObject {
    @Published var currentIndex: Int
    @Published var image: UIImage?
    
    let images: [ImageData]
    private var cancellable: AnyCancellable?
    private let imageLoader: ImageLoader
    
    /// Initializes the view model with an array of images and the starting index.
    init(images: [ImageData], currentIndex: Int) {
        self.images = images
        self.currentIndex = currentIndex
        self.imageLoader = ImageLoader()
    }
    
    /// Loads the current image based on the current index.
    func loadCurrentImage() {
        let currentImageData = images[currentIndex]
        imageLoader.load(from: currentImageData.url)
        cancellable = imageLoader.$image
            .assign(to: \.image, on: self)
    }
    
    /// Moves to the next image if available.
    func moveToNextImage() {
        guard currentIndex < images.count - 1 else { return }
        currentIndex += 1
        loadCurrentImage()
    }
    
    /// Moves to the previous image if available.
    func moveToPreviousImage() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        loadCurrentImage()
    }
}
