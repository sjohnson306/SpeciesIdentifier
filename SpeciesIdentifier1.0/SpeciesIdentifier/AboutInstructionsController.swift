//
//  AboutInstructionsController.swift
//  SpeciesIdentifier
//
//  Created by Samuel Johnson on 11/26/18.
//  Copyright © 2018 sJohnson. All rights reserved.
//

import UIKit


/// this class is responsible for creating (and dismissing) the view that appears when the user taps either the 'instructions' or 'about' button on the main screen.
class AboutInstructionsController: UIViewController {
    
    /// specifies which button was tapped
    var buttonTapped: ButtonTapped?
    
    /// creates the view's textview, which holds the text that the user will read
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = view.backgroundColor
        
        // give a default value for the info string in case the buttonTapped object is nil
        let infoString = buttonTapped?.rawValue ?? "Created by Samuel Johnson, 2018"
        textView.attributedText = infoString.toAttributedStringWith(fontSize: 16, lineSpacing: 15)

        return textView
    }()
    
    /// creates and gives some specifications for the view's dismiss button, which closes the view
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        // bluish color to match main screen background
        button.backgroundColor = UIColor(red: 48/255, green: 153/255, blue: 192/255, alpha: 1)
        
        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(AboutInstructionsController.dismissButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// required initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// custom initializer that passes in which button was tapped.
    init(button: ButtonTapped) {
        buttonTapped = button
        super.init(nibName: nil, bundle: nil)
    }

    
    /// adds the label and button to the view, and specifies their constraints
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // set view's background color to a grayish hue
        view.backgroundColor = UIColor(red:0.92, green:0.91, blue:0.90, alpha:1.0)
        
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            // set view to end at top of dismiss button, 50 pts
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
            ])

        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dismissButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    /// dismisses the view, returning the screen to the main view
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

/// an enum to specify which button was tapped by the user, and holds the text to be displayed in each instance
enum ButtonTapped: String {
    case about = """
    
    This app was created for Samuel Johnson’s capstone project in software engineering at Ferris State University. The machine learning model was trained using the Caltech-UCSD Birds-200-2011 dataset:
    
    Wah C., Branson S., Welinder P., Perona P., Belongie S. “The Caltech-UCSD Birds-200-2011 Dataset.” Computation & Neural Systems Technical Report, CNS-TR-2011-001.
    
    It should be noted that the machine learning model was only trained to distinguish between 200 species of birds, so there are many species that it is not familiar with. Hopefully, its guesses will at the least point in the right direction for correct identification. Also, the model was not trained to recognize the absence of birds. Therefore, if one submits a picture without any birds in the image, the model will still give its best guess for what type of bird it thinks it is seeing— when of course, it isn’t actually seeing a bird at all. (To this program, everything is a bird.)
    
    Special thanks to my Lord and Savior Jesus Christ, to Nate Knobloch for the background image and UI advice, and to my family.
    
    """
    case instructions = """
    
    In order to use this app, tap the ‘Select Image’ button and choose a picture of a bird from your photo library to submit to the machine learning model. If all goes well, the model will process the image and its top guess or top guesses will be displayed on the screen.
    
    The app needs permission to access your device’s photo library in order to work properly. This can be turned on in Settings > Privacy > Photos.
    
    """
}

/// adding a useful range attribute to the NSAttributedString data type
extension NSAttributedString {
    var stringRange: NSRange {
        return NSMakeRange(0, self.length) // start at position 0, apply modifier all the way to end of the string
    }
}

/// adds a method to return an attributed string from a normal string
extension String {
    func toAttributedStringWith(fontSize: CGFloat = 18, lineSpacing spacing: CGFloat = 10, rangesToBold: [NSRange] = [], centerAlignment: Bool = false) -> NSAttributedString {
        let fancyString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        
        // set line spacing
        paragraphStyle.lineSpacing = spacing
        if centerAlignment { paragraphStyle.alignment = .center }
        
        fancyString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: fancyString.stringRange)

        // bold text in set ranges
        for range in rangesToBold {
            fancyString.setAttributes([.strokeWidth: NSNumber(value: -3.0)], range: range)
        }
        
        // set text font size
        let font = UIFont(descriptor: UIFontDescriptor(), size: fontSize)
        fancyString.addAttribute(NSAttributedString.Key.font, value: font, range: fancyString.stringRange)
        
        return fancyString
        
    }
}
