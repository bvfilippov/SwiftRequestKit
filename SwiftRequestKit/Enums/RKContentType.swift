//
//  RKContentType.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

/// `RKContentType` provides a mapping between content types used in HTTP headers and their respective MIME types.
///
/// Content types (also known as MIME types) help to specify the nature and format of the data in HTTP requests and responses.
/// By using the "Content-Type" header, systems can interpret the data appropriately, be it for parsing JSON or for processing file uploads.
public enum RKContentType {
    
    // MARK: - Cases
    
    /// Represents the JSON content type, commonly used to send and receive structured data.
    case json
    /// Represents a generic binary stream, commonly used for sending and receiving binary data.
    case octetStream
    /// Represents multipart form data content type.
    /// Often used for uploads where the request may contain files and other form data.
    /// - Parameter boundary: A string that separates each part of the data in the multipart message.
    case formData(boundary: String)
    
    // MARK: - Properties
    
    /// Returns the MIME type string corresponding to the content type.
    public var value: String {
        switch self {
        case .json:
            return "application/json"
        case .octetStream:
            return "application/octet-stream"
        case .formData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
    
}
