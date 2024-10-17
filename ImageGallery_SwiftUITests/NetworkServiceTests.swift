//
//  NetworkServiceTests.swift
//  ImageGallery_SwiftUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest
import Combine
@testable import ImageGallery_SwiftUI

final class NetworkServiceTests: XCTestCase {
    var service: NetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = NetworkService.shared
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchImages_Success() {
        let expectation = self.expectation(description: "Fetch images successfully")
        
        service.fetchImages()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Expected successful fetch, but got error: \(error)")
                }
            } receiveValue: { images in
                XCTAssertFalse(images.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
