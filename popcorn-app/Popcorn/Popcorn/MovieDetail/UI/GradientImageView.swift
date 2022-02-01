//
//  GradientLayer.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 10.12.2021.
//

import Foundation
import QuartzCore
import UIKit

class GradientImageView: UIImageView {
    
    private let gradientLayer = CAGradientLayer()
    
    var colors: [UIColor] = [.clear, .white]
    
    init(image: UIImage?, colors: [UIColor]) {
        self.colors = colors
        super.init(image: image)
        clipsToBounds = true
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}
