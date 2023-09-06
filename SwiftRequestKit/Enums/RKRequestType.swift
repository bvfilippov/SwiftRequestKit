//
//  RKRequestType.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

/// Represents HTTP request methods.
///
/// HTTP methods, also known as request methods, indicate the desired action to be performed on the resource identified by a given request URL.
/// Different methods can incur different side-effects on the resource.
public enum RKRequestType: String {
    
    // MARK: - Cases
    
    /// Represents an HTTP GET request, used to retrieve data.
    case get = "GET"
    /// Represents an HTTP POST request, used to submit data to be processed.
    case post = "POST"
    /// Represents an HTTP PUT request, used to update a resource or create it if it doesn't exist.
    case put = "PUT"
    /// Represents an HTTP PATCH request, used to apply partial modifications to a resource.
    case patch = "PATCH"
    /// Represents an HTTP DELETE request, used to delete a specified resource.
    case delete = "DELETE"
    
}
