//
//  ProfilesRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 09.12.2021.
//

import Foundation

struct ProfilesRequest: Request {
    var httpMethod: HttpMethod
    
    var headers: [String : String]
    
    var baseUrl: String
    
    var path: String {
        "/person/\(artistId)/images"
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
