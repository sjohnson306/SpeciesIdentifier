//
//  Model.swift
//  SpeciesIdentifier
//
//  Created by Samuel Johnson on 11/10/18.
//  Code for model interaction created with help from Lynda course on Core ML: https://www.linkedin.com/learning/ios-app-development-core-ml
//  Thanks to the author, Brian Advent
//  and with help and some sample code from the Apple Developer website: https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml
//  Thanks also to the authors of the page there
//  Copyright © 2018 sJohnson. All rights reserved.
//

import UIKit
import Vision

/// This class is responsible for interacting with the ML model, sending it input and receiving its output (guesses and confidence).
class Model {
    
    /// Closure for providing the desired logic to be accomplished at the call site of Model class's methods
    let handler: ([VNClassificationObservation]) -> Void
    
    /// Sets up the ML model
    lazy var classificationRequest: VNCoreMLRequest = {
        do {

            let model = try VNCoreMLModel(for: BirdClassifier56().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch let error {
            // Throw a fatal error if there's a problem loading the ml model, because the app would have little functionality after a failure to load the model
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// Class initializer, requires the handler closure
    init(handler: @escaping ([VNClassificationObservation]) -> Void) {
        self.handler = handler
    }
    
    /// This method handles the logic for dealing with of results from the classification request
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                // This would be a error thrown from VNCoreMLRequest's completion handler
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.handler(classifications)
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(3)
                self.handler(Array(topClassifications))
                
            }
        }
    }
    
    /// This method updates obtains the classifications from the ML model from the image passed in. This is the method called in the SpeciesInformation class.
    func updateClassifications(for image: UIImage) throws {
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
            throw SpeciesIdentifierError.orientationError(description: "Unable to obtain orientation from image")
        }
        guard let ciImage = CIImage(image: image) else {
            throw SpeciesIdentifierError.imageError(description: "Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
}
