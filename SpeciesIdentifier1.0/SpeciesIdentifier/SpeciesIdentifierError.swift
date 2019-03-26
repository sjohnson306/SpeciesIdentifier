//
//  SpeciesIdentifierError.swift
//  SpeciesIdentifier
//
//  Created by Samuel Johnson on 11/10/18.
//  Copyright © 2018 sJohnson. All rights reserved.
//

import Foundation

/// the different errors that may be encountered in program execution
enum SpeciesIdentifierError: Error {
    case modelOutputError(description: String)
    case orientationError(description: String)
    case imageError(description: String)
}
