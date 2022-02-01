//
//  StarRatingView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 10.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAnimated

class StarRatingView: UIView {
    
    private var rating: Rating = Rating(totalFilled: 0)
    
    private lazy var stars: [UIImageView] = {
        let stars = (0..<rating.totalStars).map { _ -> UIImageView in
            let star = ViewCreator.createImageView(contentMode: .scaleAspectFill, image: Asset.Images.starGray.image)
            star.heightAnchor.constraint(equalToConstant: 20).isActive = true
            star.widthAnchor.constraint(equalTo: star.heightAnchor).isActive = true
            return star
        }
        return stars
    }()
    
    private lazy var starStackView: UIStackView = {
        return ViewCreator.createStackView(subviews: stars,
                                           axis: .horizontal,
                                           distribution: .fillEqually,
                                           alignment: .center)
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = ViewCreator.createLabel(text: "",
                                            font: FontFamily.AppleGothic.regular.font(size: 13),
                                            textColor: Asset.Colors.black.color)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [starStackView, ratingLabel],
                                                    axis: .horizontal,
                                                    distribution: .fill,
                                                    alignment: .lastBaseline)
        stackView.spacing = 10
        return stackView
    }()
    
    init(withLabel: Bool) {
        super.init(frame: .zero)
        ratingLabel.isHidden = withLabel ? false : true
        addSubview(ratingStackView)
        setupConstraints()
    }
    
    func configure(with rating: Rating) {
        self.rating = rating
        
        if rating.totalFilled > 0 {
            (1...rating.totalFilled).forEach { [weak self] idx in self?.stars[idx - 1].image = Asset.Images.starYellow.image }
        }
        if !self.ratingLabel.isHidden {
            self.ratingLabel.text = " \(rating.totalFilled) / \(rating.totalStars)"
        }
    }
    
    func reset() {
        stars.forEach { $0.image = Asset.Images.starGray.image }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: ratingStackView.heightAnchor),
            widthAnchor.constraint(equalTo: ratingStackView.widthAnchor),
            ratingStackView.topAnchor.constraint(equalTo: topAnchor),
            ratingStackView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
}
