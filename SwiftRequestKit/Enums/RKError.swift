//
//  RKError.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

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
    /// Indicates an invalid URL format or structure. (новый комментарий)
    case invalidURL

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
            return "noInternetConnectionTitle".localize
        case .unexpectedResponseCode:
            return "unexpectedResponseCodeTitle".localize
        case .responseWithoutContent:
            return "responseWithoutContentTitle".localize
        case .genericServerError:
            return "genericServerErrorTitle".localize
        case .failedToDecodeResponse:
            return "failedToDecodeResponseTitle".localize
        case .failedConnection:
            return "failedConnectionTitle".localize
        case .authenticationRequired:
            return "authenticationRequiredTitle".localize
        case .invalidURL:
            return "invalidURLTitle".localize
        }
    }
    
    /// A more detailed error message suitable for user feedback and debugging.
    public var detailedMessage: String? {
        switch self {
        case .noInternetConnection:
            return "noInternetConnectionMessage".localize
        case .unexpectedResponseCode:
            return "unexpectedResponseCodeMessage".localize
        case .genericServerError:
            return "genericServerErrorMessage".localize
        case .responseWithoutContent:
            return "responseWithoutContentMessage".localize
        case .failedToDecodeResponse(let data):
            return "failedToDecodeResponseMessage".localized(withArguments: String(data: data ?? Data(), encoding: .utf8) ?? "N/A")
        case .failedConnection:
            return "failedConnectionMessage".localize
        case .authenticationRequired:
            return "authenticationRequiredMessage".localize
        case .invalidURL:
            return "invalidURLMessage".localize
        }
    }
    
}
