//
//  TabModuleFactory.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit

protocol TabBarModuleFactory {
    func makeDiscoverCoordinator() -> DiscoverCoordinator
    func makeGenresCoordinator() -> GenresCoordinator
    func makeArtistsCoordinator() -> ArtistsCoordinator
}

extension DependencyContainer: TabBarModuleFactory {
    func makeDiscoverCoordinator() -> DiscoverCoordinator {
        let navigationVC = CustomNavigationController()
        navigationVC.tabBarItem = UITabBarItem(title: L10n.discoverSection, image: Asset.Images.discover.image, selectedImage: nil)
        let coordinator = DiscoverCoordinator(navigationController: navigationVC, factory: self)
        return coordinator
    }
    
    func makeGenresCoordinator() -> GenresCoordinator {
        let navigationVC = CustomNavigationController()
        navigationVC.tabBarItem = UITabBarItem(title: L10n.genreSection, image: Asset.Images.genres.image, selectedImage: nil)
        let coordinator = GenresCoordinator(navigationController: navigationVC, factory: self)
        return coordinator
    }
    
    func makeArtistsCoordinator() -> ArtistsCoordinator {
        let navigationVC = CustomNavigationController()
        navigationVC.tabBarItem = UITabBarItem(title: L10n.artistSection, image: Asset.Images.artists.image, selectedImage: nil)
        let coordinator = ArtistsCoordinator(navigationController: navigationVC, factory: self)
        return coordinator
    }
}
