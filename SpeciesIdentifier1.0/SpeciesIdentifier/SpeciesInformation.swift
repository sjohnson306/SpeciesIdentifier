//
//  SpeciesInformation.swift
//  SpeciesIdentifier
//
//  Created by Samuel Johnson on 11/10/18.
//  Copyright © 2018 sJohnson. All rights reserved.
//

import Foundation
import Vision
import UIKit

/// this class is responsible for mediating between the Model class and the ViewController class, so that the ViewController class only needs to interact with this class and not the Model class to obtain model guesses for images.
class SpeciesInformation {
    
    /// ranges of the description string to bold when written to the UI (species names)
    var boldRanges = [NSRange]()
    
    /// the description of the ML model's output
    var description = ""

    /// Acquires a guess from the ML model from an image input. Requires a closure to be passed in to specify the logic to be executed upon receiving the model's response (happens asynchronously). This is the main method to be called inside the ViewController class.
    func getModelGuess(from image: UIImage, UIHandler: @escaping ([VNClassificationObservation]) -> Void) {
        let model = Model(handler: UIHandler)
        
        do {
            try model.updateClassifications(for: image)
        } catch SpeciesIdentifierError.imageError(let description) {
            print(description)
        } catch SpeciesIdentifierError.orientationError(let description) {
            print(description)
        } catch let error {
            print(error)
        }
    }
    
    /// returns either a string with the ML model's top guess and its confidence (for a top guess confidence of above 70%) or the model's top 3 guesses and confidences (for a top guess confidence of below 70%).
    internal func getDescription(guesses: [VNClassificationObservation]) -> NSAttributedString {
        
        var lineSpacing: CGFloat = 0
        
        // set spacing just before returning from the function-- to ensure text stays readable on smaller screen sizes
        defer {
            if description.count > 50 {
                lineSpacing = 0
            } else {
                lineSpacing = 5
            }
        }
        
        if guesses.isEmpty {
            return description.toAttributedStringWith(lineSpacing: 5, rangesToBold: boldRanges)
        }
        
        let topGuess = guesses[0]
        
        // if top guess confidence is above 70%
        if topGuess.confidence > 0.7 {
            description = "Top guess: "
            let startOfRange = description.count
            
            description += "\(topGuess.identifier)"
            let lengthOfRange = "\(topGuess.identifier)".count
            description += " [confidence: \(Int(topGuess.confidence * 100))%]"
            
            boldRanges.append(NSMakeRange(startOfRange, lengthOfRange)) // range to be bolded later
            // replace underlines in species name with spaces
            return description.replacingOccurrences(of: "_", with: " ")
                .toAttributedStringWith(lineSpacing: lineSpacing, rangesToBold: boldRanges, centerAlignment: true)
        }
        
        // if top guess confidence is 70% or below
        description = "Guesses are:"
        for guess in guesses {
            let startOfRange = description.count
            description += " \(guess.identifier)"
            let lengthOfRange = " \(guess.identifier)".count
            description += " [confidence: \(Int(guess.confidence * 100))%],"
            
            boldRanges.append(NSMakeRange(startOfRange, lengthOfRange)) // ranges to be bolded later
        }
        description.removeLast()
        description += "." // end the sentence
        
        
        // replace underlines in species names with spaces
        return description.replacingOccurrences(of: "_", with: " ")
            .toAttributedStringWith(lineSpacing: lineSpacing, rangesToBold: boldRanges, centerAlignment: true)
    }
    


}
