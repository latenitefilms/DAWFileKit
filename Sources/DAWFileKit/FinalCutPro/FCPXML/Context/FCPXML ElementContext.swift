//
//  FCPXML ElementContext.swift
//  DAWFileKit • https://github.com/orchetect/DAWFileKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS) // XMLNode only works on macOS

import Foundation
import OTCore

extension FinalCutPro.FCPXML {
    /// Wrapper for a dictionary key name that also contains strong type information about its
    /// expected value.
    public struct ElementContext<Value> {
        public let valueBuilder: ValueBuilder
        
        public init(
            value: @escaping ValueBuilder
        ) {
            valueBuilder = value
        }
        
        /// Returns the context value using the associated context value builder.
        ///
        /// - Parameters:
        ///   - element: The element.
        ///   - breadcrumbs: All ancestors traversed including resource jumps.
        ///     Ordered nearest to furthest ancestor.
        ///   - resources: The document's `resources` container element.
        ///     If `nil`, the `resources` found in the document will be used if present.
        public func value(
            from element: XMLElement,
            breadcrumbs: [XMLElement],
            resources: XMLElement? // `resources` container element
        ) -> Value {
            let tools = Tools(
                element: element,
                breadcrumbs: breadcrumbs,
                resources: resources
            )
            
            let resources = resources
                ?? element.fcpRootResources
                ?? XMLElement(name: ElementType.resources.rawValue)
            
            return valueBuilder(
                element,
                breadcrumbs,
                resources,
                tools
            )
        }
    }
}

extension FinalCutPro.FCPXML.ElementContext {
    /// Context value builder closure for an element.
    ///
    /// - Parameters:
    ///   - element: The element.
    ///   - breadcrumbs: All ancestors traversed including resource jumps.
    ///     Ordered nearest to furthest ancestor.
    ///   - resources: The document's `resources` container element provided for convenience.
    ///   - tools: Convenience methods for building context.
    public typealias ValueBuilder = (
        _ element: XMLElement,
        _ breadcrumbs: [XMLElement],
        _ resources: XMLElement, // `resources` container element
        _ tools: Tools
    ) -> Value
}

#endif
