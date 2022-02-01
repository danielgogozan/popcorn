//
//  AppModuleFactory.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation
import UIKit

protocol AppModuleFactory {
    func makeTabBarCoordinator() -> TabBarCoordinator
}

extension DependencyContainer: AppModuleFactory {
    
    func makeTabBarCoordinator() -> TabBarCoordinator {
        let tabController = UITabBarController()
        tabController.tabBar.tintColor = Asset.Colors.green.color
        tabController.tabBar.backgroundColor = .white
        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabController, factory: self)
        return tabBarCoordinator
    }
}
