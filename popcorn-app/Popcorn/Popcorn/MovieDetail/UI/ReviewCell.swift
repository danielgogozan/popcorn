//
//  ReviewCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxAnimated

class ReviewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ReviewCell.self)
    
    private var viewModel: ReviewCellViewModel?
    
    private var disposeBag: DisposeBag?
    
    private var expand: (() -> Void)?
    
    private lazy var avatar: CircularImageView =  {
        ViewCreator.createCircularImageView(contentMode: .scaleAspectFill, image: Asset.Images.highlight.image)
    }()
    
    private lazy var lineImageView: UIImageView =  {
        ViewCreator.createImageView(contentMode: .scaleToFill, image: Asset.Images.line.image)
    }()
    
    private lazy var nameLabel: UILabel = {
        ViewCreator.createLabel(text: "Nathan Jones Grew",
                                font: FontFamily.AppleGothic.regular.font(size: 18),
                                numberOfLines: 1,
                                textColor: .black)
    }()
    
    private lazy var dateLabel: UILabel = {
        ViewCreator.createLabel(text: "Mar 4th 2016",
                                font: FontFamily.AppleGothic.regular.font(size: 12),
                                numberOfLines: 1,
                                textColor: Asset.Colors.darkGray.color)
    }()

    private lazy var ratingView: StarRatingView = {
        let view = StarRatingView(withLabel: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel  = {
        let label = ViewCreator.createLabel(text: "description...",
                                            font: FontFamily.AppleGothic.regular.font(size: 16),
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
    
    private lazy var likeButton: UIButton = {
        ViewCreator.createButton(image: Asset.Images.like.image)
    }()
    
    private lazy var votesLabel: UILabel = {
        ViewCreator.createLabel(text: "15325 helpful votes",
                                font: FontFamily.AppleGothic.regular.font(size: 13),
                                numberOfLines: 1,
                                textColor: Asset.Colors.green.color)
    }()
    
    private lazy var nameAndDateStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [nameLabel, dateLabel],
                                                    axis: .vertical,
                                                    distribution: .fillProportionally,
                                                    alignment: .leading)
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var nameDateStarsStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [nameAndDateStackView, ratingView],
                                                    axis: .horizontal,
                                                    distribution: .fillProportionally,
                                                    alignment: .center)
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [nameDateStarsStackView, lineImageView],
                                                    axis: .vertical,
                                                    distribution: .fillProportionally,
                                                    alignment: .leading)
        return stackView
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [avatar, rightStackView],
                                                    axis: .horizontal,
                                                    distribution: .fillProportionally,
                                                    alignment: .center)
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0)
        return stackView
    }()
    
    private lazy var likeAndVotesStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [likeButton, votesLabel],
                                                    axis: .horizontal,
                                                    distribution: .fillProportionally,
                                                    alignment: .center)
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0)
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let descriptionStack = ViewCreator.createStackView(subviews: [descriptionLabel],
                                                           axis: .vertical,
                                                           distribution: .fillProportionally,
                                                           alignment: .leading)
        descriptionStack.isLayoutMarginsRelativeArrangement = true
        descriptionStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        let stackView = ViewCreator.createStackView(subviews: [upperStackView, descriptionStack, buttonView, likeAndVotesStackView],
                                                    axis: .vertical,
                                                    distribution: .equalSpacing,
                                                    alignment: .leading)
        stackView.backgroundColor = .white
        stackView.spacing = 5
        stackView.layer.cornerRadius = 5
        stackView.clipsToBounds = true
        stackView.setCustomSpacing(0, after: descriptionLabel)
        return stackView
    }()
    
    private lazy var spaceView: UIView = {
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.backgroundColor = Asset.Colors.lightGray.color
        return spaceView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        addSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    func configure(viewModel: ReviewCellViewModel, expand: @escaping () -> Void) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.expand = expand
        bindViewModel()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = Asset.Colors.lightGray.color
        contentView.layer.cornerRadius = 2.5
        contentView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(contentStackView)
    }
    
    private func setupConstraint() {
        upperStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        likeAndVotesStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            contentStackView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            
            avatar.heightAnchor.constraint(equalToConstant: 50),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            
            upperStackView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            upperStackView.leftAnchor.constraint(equalTo: contentStackView.leftAnchor),
            upperStackView.rightAnchor.constraint(equalTo: contentStackView.rightAnchor),
            nameDateStarsStackView.rightAnchor.constraint(equalTo: upperStackView.rightAnchor),
            lineImageView.rightAnchor.constraint(equalTo: nameDateStarsStackView.rightAnchor),
            
            viewAllButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor,constant: -5),
            viewAllButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            buttonView.heightAnchor.constraint(equalTo: viewAllButton.heightAnchor),
            buttonView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
    }
    
    private func bindViewModel() {
        guard let disposeBag = disposeBag else {
            return
        }
        
        viewModel?.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel?.date.drive(dateLabel.rx.text).disposed(by: disposeBag)
        viewModel?.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel?.rating.asObservable()
            .subscribe(onNext: { [weak self] rating in
                self?.ratingView.configure(with: rating)
            })
            .disposed(by: disposeBag)
        
        viewModel?.avatar
            .drive(avatar.rx.animated.fade(duration: 0.3).image)
            .disposed(by: disposeBag)
        
        if viewModel?.isExpanded ?? false {
            descriptionLabel.numberOfLines = 0
            viewAllButton.setTitle("view less", for: .normal)
        }
        else {
            descriptionLabel.numberOfLines = 3
            viewAllButton.setTitle("view more", for: .normal)
        }
    }
    
    @objc func viewAll() {
        expand?()
    }
}

