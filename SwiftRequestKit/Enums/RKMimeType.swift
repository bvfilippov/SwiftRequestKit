//
//  RKMimeType.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

/// `RKMimeType` provides a mapping between commonly used file formats and their respective MIME types.
///
/// MIME types (Multipurpose Internet Mail Extensions) are a way of identifying files on the Internet according to their nature and format.
/// For example, using the "Content-Type" header value defined in a HTTP response, the browser can open the file with the appropriate extension or plugin.
public enum RKMimeType {
    
    // MARK: - Cases
    
    /// Represents the JPEG image format.
    case jpeg
    /// Represents the PNG image format.
    case png
    /// Represents the Portable Document Format.
    case pdf
    /// Represents the Microsoft Word (2007 and later) document format.
    case docx
    
    // MARK: - Properties
    
    /// Returns the standard file extension for the associated format.
    public var fileExtension: String {
        switch self {
        case .jpeg:
            return "jpeg"
        case .png:
            return "png"
        case .pdf:
            return "pdf"
        case .docx:
            return "docx"
        }
    }
    
    /// Returns the MIME type string corresponding to the file format.
    public var mimeType: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        case .pdf:
            return "application/pdf"
        case .docx:
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        }
    }
    
}
