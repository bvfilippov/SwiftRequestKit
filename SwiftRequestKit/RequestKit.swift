//
//  RequestKit.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 9/5/23.
//  Copyright © 2023 Bogdan Filippov. All rights reserved.
//

import Foundation

public class RequestKit {

    // MARK: - Core Properties
        
    private let url: String
    private let type: RKRequestType

    // MARK: - Header and Content Properties
    
    private var headers: [String : String]?
    private var charsetType: RKCharacterSetType = .utf8
    private var acceptType: RKAcceptType = .json
    private var contentType: RKContentType = .json
    private var acceptLanguage = Locale.current.identifier

    // MARK: - Parameter Properties
    
    private var codableParameters: Codable?
    private var dictionaryParameters: [String : Any] = [:]

    // MARK: - Media Properties
    
    private var media: Data?
    private var mediaName: String?

    // MARK: - Miscellaneous Properties
    
    private var networkService: RKNetworkService?
    private var queue: DispatchQueue = .main
    private var repairMode: Bool = false

    // MARK: - Initializers
    
    public init(url: String, with type: RKRequestType) {
        self.url = url
        self.type = type
    }
    
    // MARK: - Header and Content Builder Methods
    
    public func setHeaders(_ headers: [String : String]) -> RequestKit {
        self.headers = headers
        return self
    }
    
    public func setCharsetType(_ charsetType: RKCharacterSetType) -> RequestKit {
        self.charsetType = charsetType
        return self
    }
    
    public func setAcceptType(_ acceptType: RKAcceptType) -> RequestKit {
        self.acceptType = acceptType
        return self
    }
    
    public func setContentType(_ contentType: RKContentType) -> RequestKit {
        self.contentType = contentType
        return self
    }
    
    public func setAcceptLanguage(_ acceptLanguage: String) -> RequestKit {
        self.acceptLanguage = acceptLanguage
        return self
    }
    
    // MARK: - Parameter Builder Methods
    
    public func setParameters(_ parameters: Codable) -> RequestKit {
        self.codableParameters = parameters
        return self
    }
    
    public func setParameters(_ parameters: [String : Any]) -> RequestKit {
        self.dictionaryParameters = parameters
        return self
    }
    
    // MARK: - Media Builder Methods
    
    public func setMedia(_ media: Data, with name: String) -> RequestKit {
        self.media = media
        self.mediaName = name
        return self
    }
    
    // MARK: - Miscellaneous Builder Methods
    
    public func setQueue(_ queue: DispatchQueue) -> RequestKit {
        self.queue = queue
        return self
    }
    
    public func setRepairMode(_ repairMode: Bool) -> RequestKit {
        self.repairMode = repairMode
        return self
    }
    
    // MARK: - Network Service Methods
    
    public func downloadData(completion: @escaping (Data?, Int?, RKError?) -> ()) -> URLSessionDataTask? {
        let request = configurateRequest()
        networkService = RKNetworkService(queue: queue, repairMode: repairMode)
        networkService?.downloadData(with: request, completion: completion)
        return networkService?.sessionDataTask
    }
    
    public func sendRequest<Type: Codable>(completion: @escaping (Type?, Int?, RKError?) -> Void) -> URLSessionDataTask? {
        let request = configurateRequest()
        networkService = RKNetworkService(queue: queue, repairMode: repairMode)
        networkService?.sendRequest(with: request, completion: completion)
        return networkService?.sessionDataTask
    }
    
    // MARK: - Private Utility Methods
    
    private func configurateRequest() -> URLRequest {
        let urlRequest = URL(string: url.trimmingCharacters(in: CharacterSet.urlFragmentAllowed.inverted)) ?? URL(string: url)!
        var request = URLRequest(url: urlRequest)
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

