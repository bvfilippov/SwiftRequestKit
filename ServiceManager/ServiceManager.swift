//
//  ServiceManager.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import Foundation

class ServiceManager {

    private let charset = "utf-8"
    private let accept  = "application/json"
    private let content = "application/json"
    private let multipart = "multipart/form-data; boundary="
    
    private let type: RequestType
    private let headers: [String: String]?
    private let parameters: [String: Any]
    private let media: Data?
    private let mediaName: String?
    private var request: URLRequest!
    
    init(url: String, type: RequestType, headers: [String: String]? = nil, parameters: [String: Any] = [:], media: Data? = nil, mediaName: String? = nil) {
        self.type = type
        self.headers = headers
        self.parameters = parameters
        self.media = media
        self.mediaName = mediaName
        self.request = configurateRequest(url: url, type: type)
    }
    
    private func configurateRequest(url: String, type: RequestType) -> URLRequest {
        let urlRequest = URL(string: url)!
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = headers
        
        if let media = media, let mediaName = mediaName {
            let boundary = generateBoundaryString()
            
            request.setValue("\(multipart)\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBodyWithParameters(filePathKey: mediaName, imageDataKey: media, boundary: boundary)
        } else {
            request.addValue(charset, forHTTPHeaderField: "Accept-Charset")
            request.addValue(accept, forHTTPHeaderField: "Accept")
            request.addValue(content, forHTTPHeaderField: "Content-Type")
            
            switch type {
            case .get, .delete:
                request.url = URL(string: url + RequestEncoder.get(parameters: parameters))!
                break
            case .post, .put:
                request.httpBody = RequestEncoder.json(parameters: parameters)
                break
            }
        }
        
        return request
    }
    
    static func downloadMedia(url: String, complation: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            complation(data)
        }).resume()
    }
    
    func sendRequest<Type: Codable>(repairMode: Bool, success: @escaping (Type, Int) -> (), failure: @escaping (ServiceError) -> ()) {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        guard InternetService.isAvailable() else {
            failure(.invalidInternetConnection)
            return
        }
        
        session.dataTask(with: request!) { (data, response, error) in
            if repairMode {
                print(self.request)
                if let httpBody = self.request.httpBody, let body = try? JSONSerialization.jsonObject(with: httpBody, options: .allowFragments) {
                    print(body)
                }
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
            }
            DispatchQueue.main.async {
                guard error == nil else {
                    print(error!)
                    failure(.serverError)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    failure(.invalidResponseCode)
                    return
                }
                guard let decodeData = data, let decodeJSON = try? decoder.decode(Type.self, from: decodeData) else {
                    failure(.impossibleDecodeData)
                    return
                }
                
                success(decodeJSON, response.statusCode)
            }
            }.resume()
    }
    
    private func createBodyWithParameters(filePathKey: String, imageDataKey: Data, boundary: String) -> Data {
        var body = Data()
        
        let filename = "\(filePathKey).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}
