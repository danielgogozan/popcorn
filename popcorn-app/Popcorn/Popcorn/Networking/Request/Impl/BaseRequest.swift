//
//  BaseMovieRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 18.11.2021.
//

import Foundation

class BaseRequest: Request {
    
    var httpMethod: HttpMethod
    
    var headers: [String : String]
    
    var baseUrl: String
    
    var path: String
    
    var params: [String : String]
    
    init(httpMethod: HttpMethod, path: String, headers: [String: String], params: [String: String]) {
        self.httpMethod = httpMethod
        self.headers = headers
        self.baseUrl = APIUtils.baseUrl
        self.path = path
        self.params = params
    }
    
}
