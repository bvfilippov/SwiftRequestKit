//
//  RKRequestEncodingError.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

/// Defines the set of errors that can be thrown by the `RKRequestEncoder`.
public enum RKRequestEncodingError: Error {
    case encodingFailed
    case invalidURL
}
