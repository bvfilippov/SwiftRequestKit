//
//  RequestKit.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

import Foundation

/// `RequestKit` is a utility class that aids in the creation and execution of HTTP requests.
public class RequestKit {

    // MARK: - Core Properties
        
    /// The URL endpoint for the request.
    private let url: String
    /// Type of HTTP request (e.g., GET, POST, PUT, etc.).
    private let type: RKRequestType

    // MARK: - Header and Content Properties
    
    /// Custom headers to be included in the request.
    private var headers: [String : String]?
    /// Character set used for encoding the request.
    private var charsetType: RKCharacterSetType = .utf8
    /// Specifies the expected response format.
    private var acceptType: RKAcceptType = .json
    /// Specifies the content type of the request body.
    private var contentType: RKContentType = .json
    /// Language preference for the response.
    private var acceptLanguage = Locale.current.identifier

    // MARK: - Parameter Properties
    
    /// Parameters to be sent with the request in Codable format.
    private var codableParameters: Codable?
    /// Parameters to be sent with the request in dictionary format.
    private var dictionaryParameters: [String : Any] = [:]

    // MARK: - Media Properties
    
    /// Media data (e.g., images) to be sent with the request.
    private var media: Data?
    /// Name identifier for the media.
    private var mediaName: String?

    // MARK: - Miscellaneous Properties
    
    /// Service responsible for network operations.
    private var networkService: RKNetworkService?
    /// Dispatch queue on which network callbacks are executed.
    private var queue: DispatchQueue = .main
    /// Enables or disables debug mode.
    private var debugMode: Bool = false

    // MARK: - Initializers
    
    /// Initializes a new `RequestKit` instance with the given URL and request type.
    public init(url: String, with type: RKRequestType) {
        self.url = url
        self.type = type
    }
    
    // MARK: - Header and Content Builder Methods
    
    /// Sets custom headers for the request.
    public func setHeaders(_ headers: [String : String]) -> RequestKit {
        self.headers = headers
        return self
    }
    
    /// Sets the character set for encoding the request.
    public func setCharsetType(_ charsetType: RKCharacterSetType) -> RequestKit {
        self.charsetType = charsetType
        return self
    }
    
    /// Specifies the expected response format.
    public func setAcceptType(_ acceptType: RKAcceptType) -> RequestKit {
        self.acceptType = acceptType
        return self
    }
    
    /// Sets the content type of the request body.
    public func setContentType(_ contentType: RKContentType) -> RequestKit {
        self.contentType = contentType
        return self
    }
    
    /// Sets language preference for the response.
    public func setAcceptLanguage(_ acceptLanguage: String) -> RequestKit {
        self.acceptLanguage = acceptLanguage
        return self
    }
    
    // MARK: - Parameter Builder Methods
    
    /// Sets request parameters in Codable format.
    public func setParameters(_ parameters: Codable) -> RequestKit {
        self.codableParameters = parameters
        return self
    }
    
    /// Sets request parameters in dictionary format.
    public func setParameters(_ parameters: [String : Any]) -> RequestKit {
        self.dictionaryParameters = parameters
        return self
    }
    
    // MARK: - Media Builder Methods
    
    /// Sets media data to be sent with the request.
    public func setMedia(_ media: Data, with name: String) -> RequestKit {
        self.media = media
        self.mediaName = name
        return self
    }
    
    // MARK: - Miscellaneous Builder Methods
    
    /// Sets the dispatch queue for network callbacks.
    public func setQueue(_ queue: DispatchQueue) -> RequestKit {
        self.queue = queue
        return self
    }
    
    /// Toggles debug mode.
    public func setDebugMode(_ debugMode: Bool) -> RequestKit {
        self.debugMode = debugMode
        return self
    }
    
    // MARK: - Network Service Methods
    
    /// Executes the request returning the URLSessionDataTask.
    @discardableResult
    public func execute(completion: @escaping (Data?, Int?, RKError?) -> ()) -> URLSessionDataTask? {
        guard let request = configurateRequest() else {
            completion(nil, nil, .invalidURL)
            return nil
        }
        
        networkService = RKNetworkService(queue: queue, debugMode: debugMode)
        networkService?.execute(with: request, completion: completion)
        return networkService?.sessionDataTask
    }
    
    /// Executes the request expecting a Codable response returning the URLSessionDataTask.
    @discardableResult
    public func execute<Type: Codable>(completion: @escaping (Type?, Int?, RKError?) -> Void) -> URLSessionDataTask? {
        guard let request = configurateRequest() else {
            completion(nil, nil, .invalidURL)
            return nil
        }
        
        networkService = RKNetworkService(queue: queue, debugMode: debugMode)
        networkService?.execute(with: request, completion: completion)
        return networkService?.sessionDataTask
    }
    
    // MARK: - Private Utility Methods
    
    /// Configures and returns a URLRequest based on the set properties.
    private func configurateRequest() -> URLRequest? {
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        guard let url = URL(string: encodedURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = headers
        
        switch contentType {
        case .octetStream:
            addCommonHeaders(to: &request)
            request.httpBody = media
        case .formData(boundary: let boundary):
            guard let media = media, let mediaName = mediaName else {
                break
            }
            request.setValue("\(contentType)\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = uploadingImageBody(filePathKey: mediaName, imageDataKey: media, boundary: boundary)
        case .json:
            addCommonHeaders(to: &request)
            addRequestParameters(to: &request)
        }
        
        return request
    }
    
    private func addCommonHeaders(to request: inout URLRequest) {
        request.addValue(charsetType.value, forHTTPHeaderField: "Accept-Charset")
        request.addValue(acceptType.value, forHTTPHeaderField: "Accept")
        request.addValue(contentType.value, forHTTPHeaderField: "Content-Type")
        request.addValue(acceptLanguage, forHTTPHeaderField: "Accept-Language")
    }
    
    private func addRequestParameters(to request: inout URLRequest) {
        do {
            if let parameters = codableParameters {
                switch type {
                case .get, .delete:
                    request.url = try RKRequestEncoder.urlEncode(url, parameters: parameters)
                case .post, .put, .patch:
                    request.httpBody = try RKRequestEncoder.jsonEncode(parameters)
                }
            } else {
                switch type {
                case .get, .delete:
                    request.url = dictionaryParameters.isEmpty ? URL(string: url) : try RKRequestEncoder.urlEncode(url, parameters: dictionaryParameters)
                case .post, .put, .patch:
                    request.httpBody = try RKRequestEncoder.jsonEncode(parameters: dictionaryParameters)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func uploadingImageBody(filePathKey: String, imageDataKey: Data, boundary: String, mimeType: RKMimeType = .jpeg) -> Data {
        var body = Data()
        let filename = "\(filePathKey).\(mimeType.fileExtension)"
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
}
