//
//  APIUtils.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation

struct APIUtils {
    
    static let apiKey = "6562188bb719159af30acd7bb83fc224"
    
    static let baseUrl = "https://api.themoviedb.org/3"
    
    static let imageBaseUrl = "https://image.tmdb.org/t/p/"
    
    enum PosterSize: String {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
        case original
    }
    
    enum ProfileSize: String {
        case w45
        case w185
        case h632
        case original
    }
}
