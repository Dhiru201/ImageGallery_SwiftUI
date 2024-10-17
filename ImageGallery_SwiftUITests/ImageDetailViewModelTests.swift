//
//  ImageDetailViewModelTests.swift
//  ImageGallery_SwiftUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest
@testable import ImageGallery_SwiftUI

final class ImageDetailViewModelTests: XCTestCase {
    var viewModel: ImageDetailViewModel!

    override func setUp() {
        super.setUp()
        let sampleImages = [
            ImageData(id: 1, albumId: 1, title: "First", url: "http://example.com/image1.jpg", thumbnailUrl: "http://example.com/thumb1.jpg"),
            ImageData(id: 2, albumId: 1, title: "Second", url: "http://example.com/image2.jpg", thumbnailUrl: "http://example.com/thumb2.jpg")
        ]
        viewModel = ImageDetailViewModel(images: sampleImages, currentIndex: 0)
    }

    func testMoveToNextImage() {
        viewModel.moveToNextImage()
        XCTAssertEqual(viewModel.currentIndex, 1)
        viewModel.moveToNextImage() // should not change index
        XCTAssertEqual(viewModel.currentIndex, 1)
    }

    func testMoveToPreviousImage() {
        viewModel.moveToNextImage() // Move to index 1
        viewModel.moveToPreviousImage()
        XCTAssertEqual(viewModel.currentIndex, 0)
        viewModel.moveToPreviousImage() // should not change index
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
}

