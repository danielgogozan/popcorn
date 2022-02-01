//
//  Movie.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import UIKit

struct Movie: Codable {
    
    // other movie properties will be added when needed
    let id: Int
    let title: String
    let posterPath: String?
    let genreIds: [Int]?
    let voteAverage: Float
    let voteCount: Int
    
    // MARK: some properties are available only after a movie detail request, so an optional should be used
    let duration: Int?
    let genres: [Genre]?
    let spokenLanguages: [Language]?
    let productionCountries: [Country]?
    let video: Bool?
    let releaseDate: String?
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case duration = "runtime"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case genres
        case spokenLanguages = "spoken_languages"
        case productionCountries = "production_countries"
        case video
        case releaseDate = "release_date"
        case overview
    }
    
    // vote average is in [0, 10] interval and it should be converted to [0, 5]
    var rating: Int {
        return Int((5 * voteAverage) / 10)
    }
    
    var genreString: String {
        guard let genres = genres else {
            return ""
        }
        return genres.map { $0.name }.joined(separator: " | ")
    }
    
    var explicitRating: String {
        "\(Int(voteAverage)) / 10"
    }
    
    var language: String {
        if spokenLanguages?.isEmpty ?? true {
            return ""
        }
        return spokenLanguages?[0].englishName ?? ""
    }
}

struct Movies: Codable {
    let results: [Movie]
}

struct MovieCredits: Codable {
    var cast: [Movie]
}

enum MovieSection: Int, CaseIterable {
    case popular
    case nowPlaying
    case upcoming
    case topRated
    
    var name: String {
        switch self {
        case .popular:
            return "Most Popular"
        case .nowPlaying:
            return "Now Playing"
        case .upcoming:
            return "Coming soon"
        case .topRated:
            return "Top Rated"
        }
    }
    
    var apiRequest: Request {
        switch self {
        case .popular:
            return RequestFactory.popularMoviesRequest()
        case .nowPlaying:
            return RequestFactory.noMoviesRequest()
        case .upcoming:
            return RequestFactory.upcomingMoviesRequest()
        case .topRated:
            return RequestFactory.topMoviesRequest()
        }
    }
}
