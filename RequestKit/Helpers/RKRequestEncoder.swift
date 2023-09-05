//
//  RKRequestEncoder.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

/// Provides utility functions for encoding requests for API interactions.
class RKRequestEncoder {
    
    // MARK: - Public Methods
    
    /// Encodes a `Codable` object into a URL with query parameters.
    ///
    /// - Parameters:
    ///   - host: The base URL as a string.
    ///   - parameters: The `Codable` object to be encoded.
    /// - Throws: `RKRequestEncodingError` in case of invalid URL or encoding failure.
    /// - Returns: A URL object with encoded query parameters.
    static func urlEncode<T: Codable>(_ host: String, parameters: T) throws -> URL {
        let dictionary = try encode(parameters)
        return try urlEncode(host, parameters: dictionary)
    }
    
    /// Encodes a dictionary into a URL with query parameters.
    ///
    /// - Parameters:
    ///   - host: The base URL as a string.
    ///   - parameters: The dictionary to be encoded.
    /// - Throws: `RKRequestEncodingError` in case of invalid URL.
    /// - Returns: A URL object with encoded query parameters.
    static func urlEncode(_ host: String, parameters: [String : Any]) throws -> URL {
        guard var urlComponents = URLComponents(string: host) else {
            throw RKRequestEncodingError.invalidURL
        }
        urlComponents.queryItems = queryItems(from: parameters)
        guard let url = urlComponents.url else {
            throw RKRequestEncodingError.invalidURL
        }
        return url
    }
    
    /// Encodes a `Codable` object into JSON `Data`.
    ///
    /// - Parameter value: The `Codable` object to be encoded.
    /// - Throws: Encoding errors.
    /// - Returns: Encoded JSON `Data`.
    static func jsonEncode<T: Codable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
    
    /// Converts a dictionary into JSON `Data`.
    ///
    /// - Parameter parameters: The dictionary to be converted.
    /// - Throws: Encoding errors.
    /// - Returns: Encoded JSON `Data`.
    static func jsonEncode(parameters: [String : Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    // MARK: - Private Helpers
    
    /// Encodes a `Codable` object into a dictionary.
    ///
    /// - Parameter value: The `Codable` object to be encoded.
    /// - Throws: `RKRequestEncodingError.encodingFailed` if encoding fails.
    /// - Returns: A dictionary representation of the object.
    private static func encode<T: Codable>(_ value: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return dictionary
        } else {
            throw RKRequestEncodingError.encodingFailed
        }
    }
    
    /// Converts a dictionary into an array of `URLQueryItem`s.
    ///
    /// - Parameter dictionary: The dictionary to be converted.
    /// - Returns: An array of `URLQueryItem`.
    private static func queryItems(from dictionary: [String: Any]) -> [URLQueryItem] {
        return dictionary.flatMap { (key, value) -> [URLQueryItem] in
            if let arrayValue = value as? [Any] {
                return arrayValue.map {
                    URLQueryItem(name: key, value: String(describing: $0))
                }
            } else {
                return [URLQueryItem(name: key, value: String(describing: value))]
            }
        }
    }
    
}
