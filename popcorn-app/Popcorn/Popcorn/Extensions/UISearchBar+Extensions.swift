//
//  UISearchBar+Extensions.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 21.11.2021.
//

import Foundation
import UIKit

public extension UISearchBar {
    
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        return subviews.first?.subviews.first(where: { $0 is UITextField }) as? UITextField
    }
    
}
