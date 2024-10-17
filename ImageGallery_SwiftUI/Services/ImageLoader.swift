//
//  ImageLoader.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import Foundation
import SwiftUI
import Combine

/// A class that loads images asynchronously from a URL and caches them for future use.
class ImageLoader: ObservableObject {
    /// The loaded image, published to update the UI when the image is fetched.
    @Published var image: UIImage?
    
    /// A cancellable object to manage the image loading subscription.
    private var cancellable: AnyCancellable?
    
    /// A static cache to store images for efficient reuse and to avoid redundant network requests.
    private static let cache = NSCache<NSString, UIImage>()
    
    /// Loads an image from the specified URL string.
    /// - Parameter urlString: The URL string of the image to be loaded.
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        // Check the cache for a previously loaded image
        if let cachedImage = Self.cache.object(forKey: urlString as NSString) {
            self.image = cachedImage // Use cached image if available
            return
        }
        // Create a data task publisher to fetch the image from the network
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) } // Convert data to UIImage
            .replaceError(with: nil) // Handle errors by replacing them with nil
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { [weak self] in
                // Cache the image if it was successfully loaded
                if let image = $0 {
                    Self.cache.setObject(image, forKey: urlString as NSString)
                    self?.image = $0
                } else {
                    self?.image = nil
                }
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

