//
//  ViewController.swift
//  SpeciesIdentifier
//
//  Created by Samuel Johnson on 11/10/18.
//  Code for image obtention created with help from forum here: https://stackoverflow.com/questions/46608761/picker-error-message-on-exit-encountered-while-discovering-extensions-error-do
//  Special thanks to the forum commenters
//  Copyright © 2018 sJohnson. All rights reserved.
//

import UIKit
import Photos

/// This class contains the logic for interactions with the UI, as well as for showing alerts and getting images from the user.
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// The UI's description label, which appears in the center-bottom portion of the screen
    @IBOutlet weak var labelDescription: UILabel?
    /// The UI's image view, which appears in the center-top portion of the screen
    @IBOutlet weak var imageView: UIImageView?
    
    /// Set the status bar (system signal bars, clock, and battery) at top of the app's screen to a light color
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    /// Logic to be run upon the view loading successfully
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up image view for default image
        imageView?.contentMode = .redraw
        imageView?.backgroundColor = .black
        
    }
    
    /// Logic for freeing up unnecessary objects taking up memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Logic to be run after user taps 'select image' button. Checks for photo library permission, and presents image picker for user
    @IBAction func selectImageTapped() {
        checkPhotoLibraryPermission {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    /// Logic to be run after user taps 'about' button. Presents second view with relevant information.
    @IBAction func aboutTapped(_ sender: Any) {
        let controller = AboutInstructionsController(button: .about)
        show(controller, sender: self)

    }
    
    /// Logic to be run after user taps 'instructions' button. Presents second view with instructions.
    @IBAction func instructionsTapped(_ sender: Any) {
        let controller = AboutInstructionsController(button: .instructions)
        show(controller, sender: self)
        
    }
    
    /// Logic for determining whether or not the user has granted access to the device's photo library, and asking for permission if necessary (and possible)
    func checkPhotoLibraryPermission(handler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // Access has already been granted by the user
            handler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access is granted by the user
                    handler()
                } else {
                    // Access is denied by the user
                    self.sendAccessAlert()
                }
            }
        case .denied, .restricted: self.sendAccessAlert()
        }
    }
    
    /// Generic method for displaying alerts with text content passed in as parameters
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// Displays an alert to the user asking for access to the device photo library after said access has been denied
    func sendAccessAlert() {
        showAlertWith(title: "Photo Library Access Restricted", message: "Please enable photo library access in settings to use this app. Don't worry, the photos never leave your device.")
    }
    
    /// The delegate function for displaying an 'image picker' so that the user can select an image from the device library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        do {
            guard let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                throw SpeciesIdentifierError.imageError(description: "Problem with getting an image from the user")
            }
            feedModel(with: pickerImage)
            dismiss(animated: true)
        }
        catch SpeciesIdentifierError.imageError {
            showAlertWith(title: "Problem getting image", message: "There was a problem getting that image. Please try again.")
        }
        catch let error {
            print("Error occurred in getting image: \(error)")
        }
    }
    
    /// Takes the user-selected image and updates the UI imageview and the UI description label with output from the ML model.
    /// Optional handler added for testing purposes.
    func feedModel(with image: UIImage, handler: (() -> Void)? = nil) {
        // update image view
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = image
        labelDescription?.text = "Loading results..."
        
        let speciesInfo = SpeciesInformation()
        speciesInfo.getModelGuess(from: image) {guesses in
            DispatchQueue.main.async {
                let description = speciesInfo.getDescription(guesses: guesses)
                self.labelDescription?.attributedText = description
                
                if let handler = handler {
                    handler()
                }
            }

        }
        
    }
    
}

