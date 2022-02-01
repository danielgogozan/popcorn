//
//  MovieCreditsRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 03.12.2021.
//

import Foundation

struct MovieCreditsRequest: Request {
    var httpMethod: HttpMethod
    
    var headers: [String : String]
    
    var baseUrl: String
    
    var path: String {
        "/person/\(artistId)/movie_credits"
    }
    
    var params: [String : String]
    
    private let artistId: Int
    
    init(artistId: Int, httpMethod: HttpMethod, headers: [String: String], params: [String: String]) {
        self.artistId = artistId
        self.httpMethod = httpMethod
        self.headers = headers
        self.baseUrl = APIUtils.baseUrl
        self.params = params
    }
}
