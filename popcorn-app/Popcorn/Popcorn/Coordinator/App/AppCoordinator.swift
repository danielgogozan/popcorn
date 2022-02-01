//
//  AppContainer.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let factory: AppModuleFactory
    private let window: UIWindow
    private var tabCoordinator: TabBarCoordinator?
    
    init(window: UIWindow, factory: AppModuleFactory) {
        self.window = window
        self.factory =  factory
    }
    
    func start() {
        let tabCoordinator = factory.makeTabBarCoordinator()
        window.rootViewController = tabCoordinator.rootViewController
        self.tabCoordinator = tabCoordinator
        self.tabCoordinator?.start()
    }
}


