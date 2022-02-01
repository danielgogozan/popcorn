//
//  DiscoverContainer.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation
import UIKit

final class DiscoverCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    
    private let navigationController: UINavigationController
    private let factory: DiscoverModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: DiscoverModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
            let discoverViewController = factory.makeDiscoverViewController()
            navigationController.setViewControllers([discoverViewController], animated: true)
            discoverViewController.onSearch = { [unowned self] in
                self.showMovieSearch()
            }
            wasLoaded = true
        }
    }
    
    func showMovieSearch() {
        let movieSearchViewController = factory.makeMovieSearchViewController()
        movieSearchViewController.onBack = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        movieSearchViewController.onSearchError = { [unowned self] errorMessage in
            let cancelAction = UIAlertAction(title: "Ok", style: .destructive)
            ViewCreator.presentAlertMessage(viewController: self.navigationController, title: "Oops, something went wrong", message: errorMessage, actions: [cancelAction])
        }
        movieSearchViewController.onDetail = { [unowned self] movieViewModel in
            showMovieDetail(movieViewModel: movieViewModel)
        }
        self.navigationController.pushViewController(movieSearchViewController, animated: true)
    }
    
    func showMovieDetail(movieViewModel: MovieViewModel) {
        let movieDetailViewController = factory.makeMovieDetailViewController(viewModel: movieViewModel)
        movieDetailViewController.onBack = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        self.navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}
