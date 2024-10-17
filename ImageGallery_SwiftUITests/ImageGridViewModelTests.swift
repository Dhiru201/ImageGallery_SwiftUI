//
//  ImageGridViewModelTests.swift
//  ImageGallery_SwiftUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest
import Combine
@testable import ImageGallery_SwiftUI

final class ImageGridViewModelTests: XCTestCase {
    var viewModel: ImageGridViewModel!
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = ImageGridViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchImages() {
            let expectation = XCTestExpectation(description: "Fetch images")
            viewModel.fetchImages()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertFalse(self.viewModel.images.isEmpty, "Images should be fetched")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10)
        }
    
    func testFetchImages_Success() {
        let expectation = self.expectation(description: "Fetch images successfully")
        
        viewModel.$images
            .dropFirst()
            .sink { images in
                XCTAssertFalse(images.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchImages()
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
