//
//  RKAcceptType.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

/// Represents various accept types for a network request.
enum RKAcceptType: String {
    
    // MARK: - Cases
    
    /// JSON accept type.
    case json = "application/json"
    /// XML accept type.
    case xml = "application/xml"
    /// HTML accept type.
    case html = "text/html"
    /// Text accept type.
    case text = "text/plain"
    /// Form URL Encoded accept type.
    case formURLEncoded = "application/x-www-form-urlencoded"
    /// PDF accept type.
    case pdf = "application/pdf"
    /// JPEG image accept type.
    case jpeg = "image/jpeg"
    /// PNG image accept type.
    case png = "image/png"
    
    // MARK: - Properties
    
    /// Returns the string representation of the accept type.
    var value: String {
        return rawValue
    }
}
