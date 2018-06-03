//
//  RequestEncoder.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

class RequestEncoder {
    
    static func get(parameters: [String: Any]) -> String {
        var string = ""
        for (key, value) in parameters {
            guard string != "" else {
                string += "?\(key)=\(value)"
                continue
            }
            string += "&\(key)=\(value)"
        }
        return string
    }
    
    static func json(parameters: [String: Any]) -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return nil }
        return json
    }
}
