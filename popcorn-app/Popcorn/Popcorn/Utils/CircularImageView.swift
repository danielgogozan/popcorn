//
//  CircularImageView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 14.12.2021.
//

import UIKit

class CircularImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
}
