//
//  APICaller.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Error {
    case statusCodeError
    case receiveNilData
    case failedToParse
}

protocol Request {
    var url: String { get }
    var params: [(key: String, value: String)] { get }
}


/// A Struct  that handles API calls.
struct APICaller {
    
    public var httpHeader: [String: String]? = ["content-type": "application/json"]
    public var timeoutInterval: TimeInterval = 60
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    /// Fire a request to the API
    /// - Parameters:
    ///   - httpMethod: HTTPMethod representing the http method (GET or POST)
    ///   - request: Request representing the request to be fired
    ///   - completion: Completion handler that returns a result type of either Data or APIError
    func fireRequest(httpMethod: HTTPMethod, request: Request, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let urlRequest = URLRequestCreator.createURLRequest(httpMethod: httpMethod,
                                                  request: request,
                                                  header: httpHeader,
                                                  timeoutInterval: timeoutInterval,
                                                  cachePolicy: cachePolicy)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.receiveNilData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode else {
                return completion(.failure(.statusCodeError))
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

// MARK: - URL Request Creator
struct URLRequestCreator {
    
    static func createURLRequest(httpMethod: HTTPMethod, request: Request, header: [String: String]?, timeoutInterval: TimeInterval, cachePolicy: URLRequest.CachePolicy) -> URLRequest {

        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        
        if let httpHeader = header {
            httpHeader.forEach {
                urlRequest.setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
        
        if httpMethod == .get {
            let params = URLEncoder.encode(params: request.params)
            let urlString = "\(request.url)/?\(params)"
            urlRequest.url = URL(string: urlString)
        } else {
            urlRequest.url = URL(string: request.url)
            urlRequest.httpBody = URLEncoder.encode(params: request.params).data(using: String.Encoding.utf8, allowLossyConversion: false)
        }
        
        print("Request: \(urlRequest.httpMethod) \(urlRequest.url!)")
        return urlRequest as URLRequest
    }
}


// MARK: - URL Encoder
struct URLEncoder {
    
    /// Encodes the URL parameters to a single string (ex.: name=rick&status=alive)
    static func encode(params: [(key: String, value: String)]) -> String {
        let encodedString = params.compactMap({ "\($0.key)=\($0.value)" }).joined(separator: "&")
        return encodedString
    }
}
