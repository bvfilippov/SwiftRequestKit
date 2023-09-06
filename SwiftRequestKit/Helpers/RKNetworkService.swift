//
//  RKNetworkService.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

import Foundation

/// A network service class responsible for sending and receiving network requests.
class RKNetworkService {
    
    // MARK: - Properties
        
    /// URLSession to execute the network tasks.
    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    /// Active URLSessionDataTask that can be managed if required.
    var sessionDataTask: URLSessionDataTask?
    /// DispatchQueue on which the completion handlers will be executed.
    let queue: DispatchQueue
    /// If set to true, debug information will be printed using the RKDebugger.
    let debugMode: Bool
    
    // MARK: - Initializers
    
    /// Creates a new instance of the network service.
    /// - Parameters:
    ///   - queue: DispatchQueue on which the completion handlers will be executed. Defaults to main.
    ///   - debugMode: If set to true, enables debug prints.
    init(queue: DispatchQueue = .main, debugMode: Bool = false) {
        self.queue = queue
        self.debugMode = debugMode
    }
    
    // MARK: - Methods

    /// Downloads data for a given URLRequest.
    /// - Parameters:
    ///   - request: URLRequest to be executed.
    ///   - completion: Completion handler to be called with Data, HTTP status code, or an error.
    func execute(with request: URLRequest, completion: @escaping (Data?, Int?, RKError?) -> ()) {
        sessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if self.debugMode {
                RKDebugger.debug(request: request, sessionDataTask: self.sessionDataTask, responseData: data)
            }
            
            self.queue.async {
                guard error == nil else {
                    completion(nil, nil, .genericServerError)
                    print(error!)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, nil, .unexpectedResponseCode)
                    return
                }
                guard let responseData = data else {
                    completion(nil, response.statusCode, .failedToDecodeResponse(data))
                    return
                }
                
                completion(responseData, response.statusCode, nil)
            }
        })
        
        sessionDataTask?.resume()
    }
    
    /// Sends a network request and decodes the response into the desired Codable type.
    /// - Parameters:
    ///   - request: URLRequest to be executed.
    ///   - completion: Completion handler to be called with Decoded data, HTTP status code, or an error.
    func execute<Type: Codable>(with request: URLRequest, completion: @escaping (Type?, Int?, RKError?) -> Void) {
        guard RKConnectivity.isAvailable else {
            completion(nil, nil, .noInternetConnection)
            return
        }
        
        sessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if self.debugMode {
                RKDebugger.debug(request: request, sessionDataTask: self.sessionDataTask, responseData: data)
            }
            
            self.queue.async {
                guard error == nil else {
                    completion(nil, nil, .genericServerError)
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, nil, .unexpectedResponseCode)
                    return
                }
                guard let data = data else {
                    completion(nil, response.statusCode, .responseWithoutContent)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodeJSON = try decoder.decode(Type.self, from: data)
                    completion(decodeJSON, response.statusCode, nil)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    RKDebugger.debug(request: request, sessionDataTask: self.sessionDataTask, responseData: data)
                    completion(nil, response.statusCode, data.isEmpty ? .responseWithoutContent : .failedToDecodeResponse(data))
                }
            }
        }
        
        sessionDataTask?.resume()
    }
    
}
