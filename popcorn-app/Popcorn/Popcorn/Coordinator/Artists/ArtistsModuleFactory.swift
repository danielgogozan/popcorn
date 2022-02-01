//
//  ArtistsModuleFactory.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation

protocol ArtistsModuleFactory {
    func makeArtistsViewController() -> ArtistsViewController
    func makeArtistDetailViewController(viewModel: ArtistCellViewModel) -> ArtistDetailViewController
}

extension DependencyContainer: ArtistsModuleFactory {
    func makeArtistsViewController() -> ArtistsViewController {
        return ArtistsViewController(viewModel: artistViewModel)
    }
    
    func makeArtistDetailViewController(viewModel: ArtistCellViewModel) -> ArtistDetailViewController {
        return ArtistDetailViewController(viewModel: viewModel)
    }
}
