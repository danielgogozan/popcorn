//
//  CastRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import Foundation

struct CastRequest: Request {
    
    var httpMethod: HttpMethod
    
    var headers: [String : String]
    
    var baseUrl: String
    
    var path: String { "/movie/\(movieId)/credits" }
    
    var params: [String : String]
    
    private let movieId: Int
    
    init(movieId: Int, httpMethod: HttpMethod, headers: [String: String], params: [String: String]) {
        self.movieId = movieId
        self.httpMethod = httpMethod
        self.headers = headers
        self.baseUrl = APIUtils.baseUrl
        self.params = params
    }
    
}
