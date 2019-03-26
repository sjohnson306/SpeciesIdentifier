//
//  SpeciesIdentifierTests.swift
//  SpeciesIdentifierTests
//
//  Created by Samuel Johnson on 11/10/18.
//  Copyright © 2018 sJohnson. All rights reserved.
//

import XCTest
import Vision
import UIKit
@testable import SpeciesIdentifier

/// Unit tests for the Species Identifier application
class SpeciesIdentifierTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    
    // MARK: SpeciesInformation class tests
    
    // Note: XCTestExpectation is used for this and other tests below due to asynchronous nature of the code being tested.
    func testCountOfGuessArray() {
        let speciesInformation = SpeciesInformation()
        let test = XCTestExpectation(description: "Test count of guess array with American_Goldfinch image")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "American_Goldfinch_0017_32272"), UIHandler: {guesses in
            DispatchQueue.main.async {
                
                if guesses.count == 3 {
                    test.fulfill()
                }
            }
        })
        
        self.wait(for: [test], timeout: 1.0)
    }
    
    func testGuessForAmericanGoldfinchImage() {
        let speciesInformation = SpeciesInformation()
        var topGuess = VNClassificationObservation()
        let test = XCTestExpectation(description: "Top guess should be American_Goldfinch")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "American_Goldfinch_0017_32272"), UIHandler: {guesses in
            DispatchQueue.main.async {
                topGuess = guesses[0]
                if topGuess.identifier == "American_Goldfinch" {
                    test.fulfill()
                }
            }
        })
        self.wait(for: [test], timeout: 1.0)
    }
    
    func testGuessForGreenVioletearImage() {
        let speciesInformation = SpeciesInformation()
        var topGuess = VNClassificationObservation()
        let test = XCTestExpectation(description: "Top guess should be Green_Violetear")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "Green_Violetear_0027_60841"), UIHandler: {guesses in
            DispatchQueue.main.async {
                topGuess = guesses[0]
                if topGuess.identifier == "Green_Violetear" {
                    test.fulfill()
                }
            }
        })
        self.wait(for: [test], timeout: 1.0)
    }
    
    func testGuessForWhitePelicanImage() {
        let speciesInformation = SpeciesInformation()
        var topGuess = VNClassificationObservation()
        let test = XCTestExpectation(description: "Top guess should be White_Pelican")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "White_Pelican_0054_97528"), UIHandler: {guesses in
            DispatchQueue.main.async {
                topGuess = guesses[0]
                if topGuess.identifier == "White_Pelican" {
                    test.fulfill()
                }
            }
        })
        self.wait(for: [test], timeout: 1.0)
    }
    
    func testGuessForClarkNutcrackerImage() {
        let speciesInformation = SpeciesInformation()
        var topGuess = VNClassificationObservation()
        let test = XCTestExpectation(description: "Top guess should be Clark_Nutcracker")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "Clark_Nutcracker_0098_85105"), UIHandler: {guesses in
            DispatchQueue.main.async {
                topGuess = guesses[0]
                if topGuess.identifier == "Clark_Nutcracker" {
                    test.fulfill()
                }
            }
        })
        self.wait(for: [test], timeout: 1.0)
    }

    
    func testGuessForRockWrenImage() {
        let speciesInformation = SpeciesInformation()
        var topGuess = VNClassificationObservation()
        let test = XCTestExpectation(description: "Top guess should be Rock_Wren")
        test.expectedFulfillmentCount = 1
        
        speciesInformation.getModelGuess(from: #imageLiteral(resourceName: "Rock_Wren_0059_188941"), UIHandler: {guesses in
            DispatchQueue.main.async {
                topGuess = guesses[0]
                if topGuess.identifier == "Rock_Wren" {
                    test.fulfill()
                }
            }
        })
        self.wait(for: [test], timeout: 1.0)
    }
    
    // MARK: AboutInstructionsController class tests
    
    func testValueOfAboutViewText() {
        let controller = AboutInstructionsController(button: .about)
        let expectedText = ButtonTapped.about.rawValue
        let viewText = controller.buttonTapped?.rawValue
        XCTAssertTrue(expectedText == viewText)
    }
    
    func testValueOfInstructionsViewText() {
        let controller = AboutInstructionsController(button: .instructions)
        let expectedText = ButtonTapped.instructions.rawValue
        let viewText = controller.buttonTapped?.rawValue
        XCTAssertTrue(expectedText == viewText)
    }
    
    func testAgainstDefaultTextForView() {
        let instructionsController = AboutInstructionsController(button: .instructions)
        let aboutController = AboutInstructionsController(button: .about)
        let aboutViewText = aboutController.buttonTapped?.rawValue
        let instructionsViewText = instructionsController.buttonTapped?.rawValue
        let badText = "Created by Samuel Johnson, 2018"
        XCTAssertFalse(aboutViewText == badText || instructionsViewText == badText)
    }
    
    // MARK: ViewController class tests
    
    func testFeedModelWithLabel() {
        let vc = ViewController()
        let label = UILabel()
        label.text = "Test Text"
        vc.labelDescription = label
        let expectedDescription = "Top guess: White Pelican"
        
        let test = XCTestExpectation(description: "Testing feedModel() and VC's descriptionLabel with image of White Pelican")
        test.expectedFulfillmentCount = 1
        
        DispatchQueue.main.async {
            vc.feedModel(with: #imageLiteral(resourceName: "White_Pelican_0054_97528")) {
                if (vc.labelDescription?.attributedText?.string.hasPrefix(expectedDescription))! {
                    test.fulfill()
                }
            }
            
        }
        wait(for: [test], timeout: 1.0)
        
    }
    
    // ensure image input is being displayed in image view (in this case, white pelican)
    func testFeedModelWithImageView() {
        let vc = ViewController()
        let imageView = UIImageView()
        vc.imageView = imageView
        let expectedImage = #imageLiteral(resourceName: "White_Pelican_0054_97528")
        
        let test = XCTestExpectation(description: "VC's imageview image should be image of White Pelican")
        test.expectedFulfillmentCount = 1
        
        DispatchQueue.main.async {
            vc.feedModel(with: #imageLiteral(resourceName: "White_Pelican_0054_97528")) {
                if vc.imageView?.image == expectedImage {
                    test.fulfill()
                }
            }
            
        }
        wait(for: [test], timeout: 1.0)
        
    }
    
    
    // MARK: Model class tests
    
    // Tests the updateClassifications() method with an image of a white pelican. This method itself calls the processClassifications() method of the model class, so we believe the class is operating properly if this test passes.
    func testUpdateClassifications() {
        let test = XCTestExpectation(description: "Top guess should be White_Pelican")
        test.expectedFulfillmentCount = 1
        
        let model = Model(handler: {guesses in
            let topGuess = guesses[0]
            if topGuess.identifier == "White_Pelican" {
                test.fulfill()
            }
        })
        do { try model.updateClassifications(for: #imageLiteral(resourceName: "White_Pelican_0054_97528")) }
        catch { XCTFail() }
        
        self.wait(for: [test], timeout: 1.0)
    }
    
    
    // MARK: Object Extension Tests
    
    func testStringRangeExtension() {
        let nsString = NSAttributedString(string: "Test String")
        let range = NSMakeRange(0, nsString.length)
        XCTAssert(range == nsString.stringRange)
    }
    
    func testToAttributedStringExtension() {
        // set up parameters
        let fontSize: CGFloat = 16
        let spacing: CGFloat = 5
        let rangesToBold = [NSMakeRange(0, 4)]
        let centerAlignment = true
    
        // string to test against
        let testString = NSMutableAttributedString(string: "This is a test string.")
        
        // set line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        if centerAlignment { paragraphStyle.alignment = .center }
        testString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: testString.stringRange)
        
        // bold text in set ranges
        for range in rangesToBold {
            testString.setAttributes([.strokeWidth: NSNumber(value: -3.0)], range: range)
        }
        
        // set text font size
        let font = UIFont(descriptor: UIFontDescriptor(), size: fontSize)
        testString.addAttribute(NSAttributedString.Key.font, value: font, range: testString.stringRange)
        
        // other string set up using the toAttributedStringWith method
        let otherString = "This is a test string.".toAttributedStringWith(fontSize: fontSize, lineSpacing: spacing, rangesToBold: rangesToBold, centerAlignment: centerAlignment)
        
        // test that the two strings are equal
        XCTAssert(testString.isEqual(otherString))
        
    }

}
