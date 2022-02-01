//
//  Coordinator.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

protocol RootContainerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}
