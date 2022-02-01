//
//  AutosizingCollectionView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 13.12.2021.
//

import Foundation
import UIKit

// Helper class to create an auto-sizing collection view based on its intrinsic content
class AutoSizingCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            contentSize
        }
    }
    
}
