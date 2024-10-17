//
//  ImageData.swift
//  ImageGallery_SwiftUI
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import Foundation

/// This model is representing image data.
struct ImageData: Codable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
