//
//  RKDebugger.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

import Foundation

class RKDebugger {

    // This function is responsible for printing request information.
    static func debug(request: URLRequest, sessionDataTask: URLSessionDataTask?, responseData: Data?) {
        if let url = request.url {
            print("URL: \(url)")
        }
        if let header = request.allHTTPHeaderFields {
            print("Request Header: \(header)")
        }
        if let httpBody = request.httpBody {
            do {
                let body = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                print("Request Body: \(body)")
            } catch {
                if let data = String(data: httpBody, encoding: .utf8) {
                    print("Request Body: \(data)")
                } else {
                    print("Request Body: \(error)")
                }
            }
        }
        
        if let code = (sessionDataTask?.response as? HTTPURLResponse)?.statusCode {
            print("Response Status Code: \(code)")
        }
        if let headers = (sessionDataTask?.response as? HTTPURLResponse)?.allHeaderFields {
            print("Response Header: \(headers)")
        }
        if let httpBody = responseData {
            do {
                let body = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                print("Response Body: \(body)")
            } catch {
                if let data = String(data: httpBody, encoding: .utf8) {
                    print("Response Body: \(data)")
                } else {
                    print("Response Body: \(error)")
                }
            }
        }
    }
}
