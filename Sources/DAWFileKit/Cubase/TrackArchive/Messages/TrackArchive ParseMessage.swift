//
//  TrackArchive ParseMessage.swift
//  DAWFileKit • https://github.com/orchetect/DAWFileKit
//

#if os(macOS) // XMLNode only works on macOS

import Foundation

extension Cubase.TrackArchive {
    
    public enum ParseMessage: Error {
        
        /// Info message.
        /// Can be disregarded and only useful for debugging.
        case info(String)
        
        /// Error message.
        /// Something was malformed or data format was not expected.
        case error(String)
        
    }
    
}

// MARK: - Extensions

extension Collection where Element == Cubase.TrackArchive.ParseMessage {
    
    /// Returns all `.info` cases as enum-unwrapped Strings.
    public var infos: [String] {
        
        reduce(into: [String]()) {
            switch $1 {
            case .info(let message):
                $0.append(message)
            default:
                break
            }
        }
        
    }
    
    /// Returns all `.error` cases as enum-unwrapped Strings.
    public var errors: [String] {
        
        reduce(into: [String]()) {
            switch $1 {
            case .error(let message):
                $0.append(message)
            default:
                break
            }
        }
        
    }
    
}

#endif
