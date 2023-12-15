//
//  FCPXMLExtractedModelElement.swift
//  DAWFileKit • https://github.com/orchetect/DAWFileKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) // XMLNode only works on macOS

import Foundation
import TimecodeKit
import OTCore

/// Protocol for extracted elements that adds contextual properties.
public protocol FCPXMLExtractedModelElement: FCPXMLExtractedElement {
    /// Concrete model type associated with the extracted element.
    associatedtype Model: FCPXMLElement
}

// MARK: - Default Implementation

extension FCPXMLExtractedModelElement {
    /// Returns the XML element wrapped in a model struct.
    public var model: Model {
        // this guard only necessary because this returns an Optional
        guard let model = Model(element: element) else {
            assertionFailure("Could not form \(Model.self) model struct.")
            return Model()
        }
        return model
    }
}

#endif
