//
//  DependencyContainer.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation

class DependencyContainer {
    private let urlSession = URLSession(configuration: .default)
    internal lazy var apiService = APIService(urlSession: urlSession)
    internal lazy var discoverViewModel = DiscoverViewModel(apiService: apiService)
    internal lazy var genreViewModel = GenreViewModel(apiService: apiService)
    internal lazy var artistViewModel = ArtistsViewModel(apiService: apiService)
}
