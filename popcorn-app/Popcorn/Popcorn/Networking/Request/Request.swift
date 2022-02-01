//
//  APIRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation

protocol Request {
    var httpMethod: HttpMethod { get }
    var headers: [String: String] { get }
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: String] { get }
}

extension Request {
    func defaultHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    func defaultParams() -> [String: String] {
        return ["api_key": APIUtils.apiKey]
    }
}

extension Request {
    func toUrlRequest() -> URLRequest {
        guard let baseUrl = URL(string: baseUrl),
            var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL or append path component \(path)")
        }
        
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            fatalError("Unable to obtain url from components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        headers.forEach { request.addValue($0, forHTTPHeaderField: $1) }
        return request
    }
}

enum HttpMethod: String {
    case GET
}
