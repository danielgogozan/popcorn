//
//  MovieDetailsView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 10.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAnimated

class MovieDetailsView: UIView {
    
    private var isExpanded = false
    private let viewModel: MovieViewModel
    private let disposeBag: DisposeBag
    
    private lazy var posterImage: UIImageView = {
        ViewCreator.createImageView(contentMode: .scaleToFill, image: Asset.Images.popcorn.image)
    }()
    
    private lazy var titleLabel: UILabel = {
        ViewCreator.createLabel(text: "Title", font: FontFamily.AppleGothic.regular.font(size: 18),
                                numberOfLines: 0,
                                textColor: Asset.Colors.black.color)
    }()
    
    private lazy var genreLabel: UILabel = {
        ViewCreator.createLabel(text: "Genres", font: FontFamily.AppleGothic.regular.font(size: 13),
                                numberOfLines: 0,
                                textColor: Asset.Colors.black.color)
    }()
    
    private lazy var languageLabel: UILabel = {
        ViewCreator.createLabel(text: "Language: English", font: FontFamily.AppleGothic.regular.font(size: 13),
                                numberOfLines: 0,
                                textColor: Asset.Colors.black.color)
    }()
    
    private lazy var dateAndRuntimeLabel: UILabel = {
        ViewCreator.createLabel(text: "June 22, 2007 (USA) 2h 10m", font: FontFamily.AppleGothic.regular.font(size: 13),
                                numberOfLines: 0,
                                textColor: Asset.Colors.black.color)
    }()
    
    private lazy var ratingView: StarRatingView = {
        let view = StarRatingView(withLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var righStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [titleLabel, genreLabel, ratingView, languageLabel, dateAndRuntimeLabel],
                                                    axis: .vertical,
                                                    distribution: .fillProportionally,
                                                    alignment: .leading)
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [posterImage, righStackView],
                                                    axis: .horizontal,
                                                    distribution: .fill,
                                                    alignment: .center)
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = ViewCreator.createLabel(text: "overview...",
                                            font: FontFamily.AppleGothic.regular.font(size: 14),
                                            numberOfLines: 3,
                                            textColor: Asset.Colors.black.color)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var viewAllButton: UIButton = {
        let button =  ViewCreator.createButton(title: "view all",
                                               font: FontFamily.AppleGothic.regular.font(size: 14),
                                               titleColor: Asset.Colors.green.color)
        button.addTarget(self, action: #selector(viewAll), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAllButton)
        return view
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [descriptionStackView, overviewLabel, buttonView],
                                                    axis: .vertical,
                                                    distribution: .fillProportionally,
                                                    alignment: .center)
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        stackView.setCustomSpacing(0, after: overviewLabel)
        return stackView
    }()
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(frame: .zero)
        addSubview(detailsStackView)
        bindViewModel()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: 170),
            posterImage.widthAnchor.constraint(equalToConstant: 130),
            
            heightAnchor.constraint(equalTo: detailsStackView.heightAnchor),
            widthAnchor.constraint(equalTo: detailsStackView.widthAnchor),
            
            detailsStackView.topAnchor.constraint(equalTo: topAnchor),
            detailsStackView.leftAnchor.constraint(equalTo: leftAnchor),
            
            viewAllButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor,constant: -5),
            viewAllButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            
            buttonView.heightAnchor.constraint(equalTo: viewAllButton.heightAnchor),
            buttonView.widthAnchor.constraint(equalTo: detailsStackView.layoutMarginsGuide.widthAnchor)
        ])
    }
    
    @objc func viewAll() {
        if isExpanded {
            overviewLabel.numberOfLines = 3
            viewAllButton.setTitle("view more", for: .normal)
        }
        else {
            overviewLabel.numberOfLines = 0
            viewAllButton.setTitle("view less", for: .normal)
        }
        isExpanded.toggle()
    }

    private func bindViewModel() {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.genre.drive(genreLabel.rx.text).disposed(by: disposeBag)
        viewModel.language.drive(languageLabel.rx.text).disposed(by: disposeBag)
        viewModel.releaseAndRuntime.drive(dateAndRuntimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.overview.drive(overviewLabel.rx.text).disposed(by: disposeBag)
        viewModel.posterImage
            .drive(posterImage.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.rating.asObservable()
            .subscribe(onNext: { [weak self] rating in
                self?.ratingView.configure(with: rating)
            })
            .disposed(by: disposeBag)
    }
}

