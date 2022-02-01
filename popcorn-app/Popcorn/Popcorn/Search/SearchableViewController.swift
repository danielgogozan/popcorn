//
//  SearchableViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 21.11.2021.
//

import Foundation
import UIKit

class SearchableViewController: UIViewController {
    
    var onSearch: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = Asset.Colors.green.color
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.Images.search.image, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(searchTapped))
    }
    
    @objc func searchTapped() {
        onSearch?()
    }
}
