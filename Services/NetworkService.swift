//
//  NetworkService.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import Foundation
import Combine

/// A singleton service for handling network requests related to image fetching.
class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = Constants.ApplicationURLS.photosUrl.rawValue
    
    /// Fetches an array of images from the network.
    /// - Returns: A publisher that emits an array of `ImageData` or an error.
    func fetchImages() -> AnyPublisher<[ImageData], Error> {
        // Ensure the URL is valid; if not, return a failed publisher
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        // Create a data task publisher and process the response
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extract the data from the response
            .decode(type: [ImageData].self, decoder: JSONDecoder()) // Decode the JSON data into an array of ImageData
            .eraseToAnyPublisher() // Return a generic AnyPublisher
    }
}

