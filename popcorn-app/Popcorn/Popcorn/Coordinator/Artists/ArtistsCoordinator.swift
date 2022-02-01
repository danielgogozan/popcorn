//
//  ArtistsCoordinator.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit

final class ArtistsCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    
    private let navigationController: UINavigationController
    private let factory: ArtistsModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: ArtistsModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
            let artistsViewController = factory.makeArtistsViewController()
            artistsViewController.onError = { [unowned self] errorMessage in
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                let retryAction = UIAlertAction(title: "Retry", style: .destructive) { _ in
                    artistsViewController.retry()
                }
                ViewCreator.presentAlertMessage(viewController: self.navigationController, title: "Oops, something went wrong", message: errorMessage, actions: [retryAction, cancelAction])
            }
            
            artistsViewController.onDetail = { [unowned self] artistViewModel in
                showArtistDetail(artistViewModel: artistViewModel)
            }
            
            navigationController.setViewControllers([artistsViewController], animated: false)
            wasLoaded = true
        }
    }
    
    func showArtistDetail(artistViewModel: ArtistCellViewModel) {
        let artistDetailViewController = factory.makeArtistDetailViewController(viewModel: artistViewModel)
        artistDetailViewController.onBack = {
            artistDetailViewController.navigationController?.popViewController(animated: true)
        }
        self.navigationController.pushViewController(artistDetailViewController, animated: true)
    }
}
