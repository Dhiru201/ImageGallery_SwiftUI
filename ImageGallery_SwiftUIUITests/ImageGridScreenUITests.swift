//
//  ImageGalleryUITests.swift
//  ImageGallery_SwiftUIUITests
//
//  Created by Dhirendra Kumar Verma on 17/10/24.
//

import XCTest

final class ImageGridScreenUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Clean up after tests
        app.terminate()
        try super.tearDownWithError()
    }
    
    func testImageGridViewLoads() throws {
        XCTAssertTrue(app.otherElements["ImageGridView"].exists)
    }
    
    func testImageGridViewIsDisplayed() throws {
        let imageGridView = app.otherElements["ImageGridView"].firstMatch
            // Wait for the grid view to appear
            let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: imageGridView, handler: nil)
            waitForExpectations(timeout: 10, handler: nil)
            
            XCTAssertTrue(imageGridView.exists, "The ImageGridView should be displayed.")
    }
    
    func testNavigationTitleExists() throws {
        let navTitle = app.navigationBars[Constants.ImageGridView.NavigationTitle.rawValue]
        XCTAssertTrue(navTitle.exists, "Navigation title should exist")
    }
    
    func testImageCellsExist() throws {
        // Wait for images to load
        let expectation = XCTestExpectation(description: "Wait for images to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
        // Use a more flexible matching strategy
        let imageCells = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH 'ImageCell-'"))
        
        XCTAssertGreaterThan(imageCells.count, 1, "There should be multiple image cells")
    }
    
    func testNavigationToDetailView() throws {
        // Wait for images to load
        let expectation = XCTestExpectation(description: "Wait for images to load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        
        let imageCells = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH 'ImageCell-'"))
        let firstCell = imageCells.firstMatch
        
        firstCell.tap()
        
        // Add a small delay after tapping to allow for navigation
        Thread.sleep(forTimeInterval: 1)
        
        // check for detail view
        let detailViewExists = isImageDetailViewPresent()
        
        XCTAssertTrue(detailViewExists, "Detail view or its components should appear after tapping an image")
    }
    
    private func isImageDetailViewPresent() -> Bool {
        if app.otherElements["ImageDetailView"].exists {
            return true
        }
        
        let navBarTitle = app.navigationBars.firstMatch.staticTexts.firstMatch.label
        if navBarTitle == Constants.ImageDetailView.NavigationTitle.rawValue {
            return true
        }
        return false
    }
    
    func testScrolling() throws {
        let imageGridView = app.otherElements["ImageGridView"]
        // Scroll down
        imageGridView.swipeUp()
        
        // Check if new cells are loaded
        let imageCells = app.descendants(matching: .any).matching(NSPredicate(format: "identifier BEGINSWITH 'ImageCell-'"))
        XCTAssertGreaterThan(imageCells.count, 1, "Should be able to see multiple cells after scrolling")
    }
}
