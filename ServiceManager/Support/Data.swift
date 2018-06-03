//
//  Data.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

extension Data {
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
