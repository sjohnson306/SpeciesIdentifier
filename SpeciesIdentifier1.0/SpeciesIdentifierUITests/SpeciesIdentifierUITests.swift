//
//  SpeciesIdentifierUITests.swift
//  SpeciesIdentifierUITests
//
//  Created by Samuel Johnson on 11/10/18.
//  Copyright © 2018 sJohnson. All rights reserved.
//

import XCTest

/// UI tests for the Species Identifier application
class SpeciesIdentifierUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    // MARK: UI Tests
    
    func testAccessingAboutView() {
        let app = XCUIApplication()
        app.buttons["About App"].tap()
        XCTAssert(app.buttons["Dismiss"].exists)
    }
    
    func testAccessingInstructionsView() {
        let app = XCUIApplication()
        app.buttons["Instructions"].tap()
        XCTAssert(app.buttons["Dismiss"].exists)
    }
    
    func testCancelingImagePicker() {
        let app = XCUIApplication()
        app.buttons["Select Image"].tap()
        app.navigationBars["Photos"].buttons["Cancel"].tap()
    }
    
    // MARK: Performance Tests
    
    func testAboutViewPerformance() {
        let app = XCUIApplication()
        let test = XCTestExpectation(description: "Should load about view in .5 seconds or less")
        test.expectedFulfillmentCount = 1
        
        app.buttons["About App"].tap()
        if app.buttons["Dismiss"].exists {
            test.fulfill()
        }
        
        self.wait(for: [test], timeout: 0.5)
    }
    
    func testInstructionsViewPerformance() {
        let app = XCUIApplication()
        let test = XCTestExpectation(description: "Should load instructions view in .5 seconds or less")
        test.expectedFulfillmentCount = 1
        
        app.buttons["Instructions"].tap()
        if app.buttons["Dismiss"].exists {
            test.fulfill()
        }
        
        self.wait(for: [test], timeout: 0.5)
    }
    
    func testImagePickerViewPerformance() {
        let app = XCUIApplication()
        let test = XCTestExpectation(description: "Should load image picker view in .5 seconds or less")
        test.expectedFulfillmentCount = 1
        
        app.buttons["Select Image"].tap()
        app.navigationBars["Photos"].buttons["Cancel"].tap()
        // test if return to main screen happened correctly
        if app.buttons["Select Image"].exists {
            test.fulfill()
        }
        
        self.wait(for: [test], timeout: 0.5)
    }
    

}
