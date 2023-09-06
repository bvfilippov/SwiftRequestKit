//
//  RKError.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

/// `ServerError` encapsulates common errors that may arise during server interactions.
///
/// Conforming to the `Error` protocol, it provides diagnostic properties and user-friendly messages
/// to handle server-related issues more gracefully.
public enum RKError: Error {
    
    // MARK: - Error Variants
    
    /// Represents a lack of internet connectivity.
    case noInternetConnection
    /// Indicates the server responded with an unexpected status code.
    case unexpectedResponseCode
    /// Represents generic server-side errors.
    case genericServerError
    /// Indicates that the server responded, but without any content.
    case responseWithoutContent
    /// Represents a failure in decoding the server response.
    case failedToDecodeResponse(Data?)
    /// Represents issues that may arise while trying to establish a connection.
    case failedConnection
    /// Indicates that the user must be authenticated to perform the given request.
    case authenticationRequired
    
    // MARK: - Diagnostic Properties
    
    /// Checks if the error is a result of a server response without content.
    public var isResponseEmpty: Bool {
        switch self {
        case .responseWithoutContent:
            return true
        default:
            return false
        }
    }
    
    /// Determines if there was a decoding issue with the server response.
    public var hasDecodingIssue: Bool {
        switch self {
        case .failedToDecodeResponse:
            return true
        default:
            return false
        }
    }
    
    /// A succinct error title suitable for user display.
    public var title: String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        case .unexpectedResponseCode:
            return "Unexpected Server Response"
        case .responseWithoutContent:
            return "Server Response Empty"
        case .genericServerError:
            return "Server Issue"
        case .failedToDecodeResponse:
            return "Data Processing Issue"
        case .failedConnection:
            return "Connection Issue"
        case .authenticationRequired:
            return "Authentication Needed"
        }
    }
    
    /// A more detailed error message suitable for user feedback and debugging.
    public var detailedMessage: String? {
        switch self {
        case .noInternetConnection:
            return "Please check your internet connection and try again."
        case .unexpectedResponseCode, .genericServerError:
            return "There seems to be an issue with our server. We apologize for the inconvenience. Kindly retry after some time."
        case .responseWithoutContent:
            return "The server responded without any data. This might be a temporary glitch. Please try again."
        case .failedToDecodeResponse(let data):
            return "There was a problem processing the data received from the server. Technical details: \(String(data: data ?? Data(), encoding: .utf8) ?? "N/A")."
        case .failedConnection:
            return "There was an issue connecting to the server. Please ensure you're connected to the internet and try again."
        case .authenticationRequired:
            return "Please log in to access this feature."
        }
    }
    
}
