//
//  GenresCoordinator.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit

final class GenresCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    
    private let navigationController: UINavigationController
    private let factory: GenresModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: GenresModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
            navigationController.setViewControllers([factory.makeGenresViewController()], animated: false)
            wasLoaded = true
        }
    }
}
