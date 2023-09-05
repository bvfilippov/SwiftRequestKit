//
//  RK+Data.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

extension Data {
    
    /// Appends the given string to the data using the specified encoding.
    /// If the string can't be encoded using the provided encoding, this method will not append anything.
    ///
    /// - Parameters:
    ///   - string: The string to append.
    ///   - encoding: The string encoding to use. Default is `.utf8`.
    mutating func appendString(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        } else {
            // You might want to handle the failure case, e.g. print an error, or throw an exception.
            print("Error: Couldn't encode the string using the provided encoding.")
        }
    }
    
}
