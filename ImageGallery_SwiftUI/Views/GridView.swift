//
//  GridView.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import SwiftUI

/// A view that displays a single image, with loading and error states.
struct GridView: View {
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.3)
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .transition(.opacity)
                } else {
                    ProgressView()
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            imageLoader.load(from: urlString)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
