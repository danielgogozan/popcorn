//
//  HighlightMovieDetailView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 10.12.2021.
//

import Foundation
import UIKit

class HighlightMovieDetailView: UIView {
    
    private lazy var highlightImage: UIImageView = {
        let image = GradientImageView(image: Asset.Images.popcorn.image, colors: [.clear, .white])
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var playButton: UIButton = {
        ViewCreator.createButton(image: Asset.Images.play.image)
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highlightImage)
        view.addSubview(playButton)
        return view
    }()
    
    private lazy var highlightStackView: UIStackView = {
        ViewCreator.createStackView(subviews: [containerView],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .leading)
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(highlightStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        DispatchQueue.main.async {
            self.highlightImage.image = image
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: highlightStackView.heightAnchor),
            widthAnchor.constraint(equalTo: highlightStackView.widthAnchor),
            highlightStackView.topAnchor.constraint(equalTo: topAnchor),
            highlightStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlightStackView.leftAnchor.constraint(equalTo: leftAnchor),
            highlightStackView.rightAnchor.constraint(equalTo: rightAnchor),
            highlightStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            containerView.heightAnchor.constraint(equalTo: highlightImage.heightAnchor),
            containerView.leftAnchor.constraint(equalTo: highlightStackView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: highlightStackView.rightAnchor),
            containerView.topAnchor.constraint(equalTo: highlightStackView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: highlightStackView.bottomAnchor),
            
            highlightImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            highlightImage.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            highlightImage.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            highlightImage.heightAnchor.constraint(equalToConstant: 300),
            highlightImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: highlightImage.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: highlightImage.centerYAnchor),
        ])
    }
    
}
