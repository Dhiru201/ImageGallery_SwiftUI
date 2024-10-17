//
//  ImageDataTests.swift
//  ImageGallery_SwiftUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest
@testable import ImageGallery_SwiftUI

final class ImageDataTests: XCTestCase {
    func testImageDecoding() {
        let jsonData = """
            {
                "albumId": 1,
                "id": 1,
                "title": "accusamus beatae ad facilis cum similique qui sunt",
                "url": "https://via.placeholder.com/600/92c952",
                "thumbnailUrl": "https://via.placeholder.com/150/92c952"
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let image = try decoder.decode(ImageData.self, from: jsonData)
            XCTAssertEqual(image.id, 1)
            XCTAssertEqual(image.title, "accusamus beatae ad facilis cum similique qui sunt")
            XCTAssertEqual(image.albumId, 1)
            XCTAssertEqual(image.url, "https://via.placeholder.com/600/92c952")
            XCTAssertEqual(image.thumbnailUrl, "https://via.placeholder.com/150/92c952")
        } catch {
            XCTFail("Failed to decode Image: \(error)")
        }
    }
}
