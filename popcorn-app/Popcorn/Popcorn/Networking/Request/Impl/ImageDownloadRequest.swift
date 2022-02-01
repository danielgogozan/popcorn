//
//  ImageDownloadRequest.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 23.11.2021.
//

import Foundation

struct ImageDownloadRequest {
    
    let baseUrl: String
    
    let path: String?
    
    let size: String?
    
    init(baseUrl: String = APIUtils.imageBaseUrl, path: String?, size: String?) {
        self.baseUrl = baseUrl
        self.path = path
        self.size = size
    }
    
    var url: URL? {
        return URL(string: baseUrl + (size ?? "") + (path ?? ""))
    }
}
