//
//  UIActivityIndicatorView+Extensions.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 26.11.2021.
//

import UIKit

extension UIActivityIndicatorView {
    
    func startLoading() {
        self.startAnimating()
        self.isHidden = false
    }
    
    func stopLoading() {
        self.stopAnimating()
        self.isHidden = true
    }
}
