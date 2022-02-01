//
//  TabCoordinator.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation
import UIKit

final class TabBarCoordinator: NSObject, RootContainerCoordinator {
    
    var rootViewController: UIViewController { tabBarController }
    private let tabBarController: UITabBarController
    private let factory: TabBarModuleFactory
    private var childCoordinators = [RootContainerCoordinator]()
    
    init(tabBarController: UITabBarController, factory: TabBarModuleFactory) {
        self.tabBarController = tabBarController
        self.factory = factory
    }
    
    func start() {
        childCoordinators.append(factory.makeDiscoverCoordinator())
        childCoordinators.append(factory.makeGenresCoordinator())
        childCoordinators.append(factory.makeArtistsCoordinator())
        tabBarController.delegate = self
        tabBarController.setViewControllers(childCoordinators.map { $0.rootViewController }, animated: false)
        childCoordinators[tabBarController.selectedIndex].start()
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        childCoordinators.first{ $0.rootViewController == viewController }?.start()
    }
}
