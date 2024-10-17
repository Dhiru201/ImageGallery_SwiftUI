//
//  ImageGridViewModel.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import Foundation
import Combine
import SwiftUI

/// ViewModel for managing the state and data of the image grid.
class ImageGridViewModel: ObservableObject {
    @Published var images: [ImageData] = []
    @Published var isLoading = false
    @Published var error: String?
    
    /// A set to hold cancellable Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Grid Configuration
    
    let spacing: CGFloat = 8
    let numberOfColumns: Int = 3
    // Define the grid layout with three flexible columns
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
    }
    
    // MARK: - Image Fetching
    /// Fetches images from the network.
    /// - This method ensures that images are only fetched when not already loading.
    func fetchImages() {
        guard !isLoading else { return }
        
        isLoading = true
        NetworkService.shared.fetchImages()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] newImages in
                self?.images.append(contentsOf: newImages)
            }
            .store(in: &cancellables)
    }
}
