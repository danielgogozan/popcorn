//
//  DiscoverModuleFactory.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation

protocol DiscoverModuleFactory {
    func makeDiscoverViewController() -> DiscoverViewController
    func makeMovieSearchViewController() -> MovieSearchViewController
    func makeMovieDetailViewController(viewModel: MovieViewModel) -> MovieDetailViewController
}

extension DependencyContainer: DiscoverModuleFactory {
    func makeDiscoverViewController() -> DiscoverViewController {
        return DiscoverViewController(viewModel: discoverViewModel)
    }
    
    func makeMovieSearchViewController() -> MovieSearchViewController {
        return MovieSearchViewController(viewModel: discoverViewModel)
    }
    
    func makeMovieDetailViewController(viewModel: MovieViewModel) -> MovieDetailViewController {
        MovieDetailViewController(viewModel: viewModel)
    }
}
