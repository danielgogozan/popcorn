//
//  ArtistCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 26.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAnimated

class ArtistCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ArtistCell.self)
    
    private var viewModel: ArtistCellViewModel?
    
    private var disposeBag: DisposeBag?
    
    private lazy var imageView: UIImageView = {
        ViewCreator.createImageView(contentMode: .scaleToFill, image: Asset.Images.popcorn.image)
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = ViewCreator.createLabel(text: "Firstname Lastname", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 2, textColor: Asset.Colors.black.color)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        ViewCreator.createStackView(subviews: [imageView, nameLabel], axis: .vertical, distribution: .fillProportionally, alignment: .center)
    }()
    
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
        imageView.image = nil
    }
    
    func configure(viewModel: ArtistCellViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        bindViews()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 2.5
        contentView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    private func bindViews() {
        guard let disposeBag = disposeBag else {
            return
        }
        
        viewModel?.poster
            .drive(imageView.rx.animated.fade(duration: 0.5).image)
            .disposed(by: disposeBag)
        
        viewModel?.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
