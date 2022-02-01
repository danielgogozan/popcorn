//
//  GenresModuleFactory.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation

protocol GenresModuleFactory {
    func makeGenresViewController() -> GenresViewController
}

extension DependencyContainer: GenresModuleFactory {
    func makeGenresViewController() -> GenresViewController {
        return GenresViewController(viewModel: genreViewModel)
    }
}
