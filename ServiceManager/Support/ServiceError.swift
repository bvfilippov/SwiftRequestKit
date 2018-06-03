//
//  ServiceError.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

enum ServiceError {
    case invalidInternetConnection
    case invalidResponseCode
    case serverError
    case impossibleDecodeData
}
