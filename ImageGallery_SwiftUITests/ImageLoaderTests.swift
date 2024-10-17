//
//  ImageLoaderTests.swift
//  ImageGallery_SwiftUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest
@testable import ImageGallery_SwiftUI

final class ImageLoaderTests: XCTestCase {
    var imageService: ImageLoader!
    
    override func setUp() {
        super.setUp()
        imageService = ImageLoader()
    }
    
    override func tearDown() {
        imageService = nil
        super.tearDown()
    }
    
    func testLoadImage_Success() {
        let expectation = self.expectation(description: "Image loaded successfully")
        let testURL = "https://via.placeholder.com/150/92c952"
        
        imageService.load(from: testURL)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.imageService.image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoadImage_Failure() {
        let expectation = self.expectation(description: "Image load failed")
        let invalidURL = "https://invalid-url.com/image.jpg"
        
        imageService.load(from: invalidURL)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNil(self.imageService.image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCancelImageLoading() {
        let testURL = "https://via.placeholder.com/150/92c952"
        imageService.load(from: testURL)
        imageService.cancel()
        XCTAssertNil(imageService.image)
    }
    
    func testLoadImageTwice_UsesCachedImage() {
            let expectation1 = self.expectation(description: "First image load")
            let expectation2 = self.expectation(description: "Second image load")
            let testURL = "https://via.placeholder.com/150/92c952"
            
        imageService.load(from: testURL)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertNotNil(self.imageService.image)
                expectation1.fulfill()
                
                let oldImage = self.imageService.image
                self.imageService.load(from: testURL)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    XCTAssertNotNil(self.imageService.image)
                    XCTAssertEqual(self.imageService.image, oldImage)
                    expectation2.fulfill()
                }
            }
            
            waitForExpectations(timeout: 15, handler: nil)
        }
    
    func testLoadMultipleImages_Concurrently() {
            let expectation = self.expectation(description: "Multiple images loaded")
            expectation.expectedFulfillmentCount = 3
            
            let urls = [
                "https://via.placeholder.com/150/92c952",
                "https://via.placeholder.com/150/771796",
                "https://via.placeholder.com/150/24f355"
            ]
            
            for url in urls {
                let loader = ImageLoader()
                loader.load(from: url)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    XCTAssertNotNil(loader.image)
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 20, handler: nil)
        }
    
    
}
