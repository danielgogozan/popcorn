//
//  DiscoverCollectionHeader.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import UIKit

class DiscoverCollectionHeader: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: DiscoverCollectionHeader.self)
    
    private lazy var sectionLabel: UILabel = {
        return ViewCreator.createLabel(text: "Most Popular", font: FontFamily.AppleGothic.regular.font(size: 16), textColor: Asset.Colors.black.color)
    }()
    
    private lazy var seeAllLabel: UILabel = {
        return ViewCreator.createLabel(text: "See All", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 1, textColor: Asset.Colors.green.color)
    }()
    
    private lazy var chevronImage: UIImageView = {
        let imageView = ViewCreator.createImageView(contentMode: .scaleAspectFit)
        imageView.image = Asset.Images.forwardChevron.image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSuviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(sectionName: String) {
        sectionLabel.text = sectionName
    }
    
    
    private func addSuviews() {
        addSubview(sectionLabel)
        addSubview(seeAllLabel)
        addSubview(chevronImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionLabel.rightAnchor.constraint(lessThanOrEqualTo: seeAllLabel.leftAnchor, constant: -10),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            chevronImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            chevronImage.heightAnchor.constraint(equalTo: sectionLabel.heightAnchor),
            seeAllLabel.rightAnchor.constraint(equalTo: chevronImage.leftAnchor, constant: -5),
            seeAllLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
