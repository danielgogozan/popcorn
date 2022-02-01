//
//  MovieCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxAnimated

class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieCell.self)
    
    private lazy var posterImageView: UIImageView = {
        return ViewCreator.createImageView(contentMode: .scaleAspectFit)
    }()
    
    private lazy var titleLabel: UILabel = {
        return ViewCreator.createLabel(text: "Title", font: FontFamily.AppleGothic.regular.font(size: 14), textColor: Asset.Colors.black.color)
    }()
    
    private lazy var durationLabel: UILabel = {
        return ViewCreator.createLabel(text: "1h, 45mins", font: FontFamily.AppleGothic.regular.font(size: 12), textColor: Asset.Colors.darkGray.color)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [posterImageView, titleLabel, durationLabel], axis: .vertical, distribution: .equalCentering, alignment: .center)
        stackView.spacing = 5
        return stackView
    }()
    
    private var movieViewModel: MovieViewModel?
    
    private var disposeBag: DisposeBag?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
        posterImageView.image = nil
    }
    
    func configure(movieViewModel: MovieViewModel) {
        self.disposeBag = DisposeBag()
        self.movieViewModel = movieViewModel
        bindViewModel()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 2.5
        contentView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(self.posterImageView)
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.durationLabel)
        contentView.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            self.stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            self.titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: stackView.leftAnchor, constant: 5),
            self.durationLabel.leftAnchor.constraint(greaterThanOrEqualTo: stackView.leftAnchor, constant: 5),
        ])
    }
    
    private func bindViewModel() {
        guard let disposeBag = disposeBag else {
            return
        }
        movieViewModel?.posterImage
            .drive(posterImageView.rx.animated.fade(duration: 0.5).image)
            .disposed(by: disposeBag)
        
        movieViewModel?.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        movieViewModel?.duration
            .drive(durationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
