//
//  CustomFlowLayout.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import UIKit

class CustomFLowLayout: UICollectionViewFlowLayout {
    
    private var widthPercent: CGFloat = 1.0
    private var heightPercent: CGFloat = 1.0
    
    init(widthPercent: CGFloat, heightPercent: CGFloat) {
        self.widthPercent = widthPercent
        self.heightPercent = heightPercent
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let itemHeight = collectionView.bounds.height * self.heightPercent
        let itemWidth = collectionView.bounds.width * self.widthPercent
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}
