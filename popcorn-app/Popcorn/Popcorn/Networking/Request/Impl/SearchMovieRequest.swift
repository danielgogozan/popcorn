//
//  SearchMovieRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import Foundation

struct SearchMovieRequest: Request {
    
    var httpMethod: HttpMethod
    
    var headers: [String : String]
    
    var baseUrl: String
    
    var path: String
    
    var params: [String : String]  {
        var params = defaultParams()
        params["query"] = searchKey
        return params
    }
    
    private let searchKey: String
    
    init(searchKey: String, httpMethod: HttpMethod, path: String, headers: [String: String]) {
        self.searchKey = searchKey
        self.httpMethod = httpMethod
        self.baseUrl = APIUtils.baseUrl
        self.path = path
        self.headers = headers
    }
}
