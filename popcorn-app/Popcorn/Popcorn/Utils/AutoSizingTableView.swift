//
//  AutosizingTableView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 13.12.2021.
//

import Foundation
import UIKit

// Helper class to create an auto-sizing table view based on its intrinsic content
class AutoSizingTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: contentSize.width + contentInset.left + contentInset.right,
                          height: contentSize.height + contentInset.top + contentInset.bottom)
        }
    }

}
