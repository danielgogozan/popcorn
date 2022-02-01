//
//  PhotoCollectionCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 09.12.2021.
//

import Foundation
import UIKit
import RxSwift

class FirstAlbumCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: FirstAlbumCollectionCell.self)
    
    
    private var viewModel: ProfileViewModel?
    private var disposeBag: DisposeBag?
    
    private lazy var photo: UIImageView = {
        let imageView = ViewCreator.createImageView(contentMode: .scaleAspectFill, image: Asset.Images.popcorn.image)
        return imageView
    }()
    
    private lazy var photoCountLabel: UILabel = {
        let label = ViewCreator.createLabel(text: "25+", font: FontFamily.AppleGothic.regular.font(size: 28), textColor: .white)
        return label
    }()
    
    private lazy var albumsLabel: UILabel = {
        let label = ViewCreator.createLabel(text: "Photo Albums", font: FontFamily.AppleGothic.regular.font(size: 14), textColor: .white)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [photoCountLabel, albumsLabel], axis: .vertical, distribution: .fillProportionally,
                                                    alignment: .center)
        return stackView
    }()
    private lazy var photoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photo)
        view.addSubview(greenView)
        view.addSubview(labelStackView)
        return view
    }()
    
    private lazy var greenView: UIView = {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Colors.green.color
        view.layer.opacity = 0.6
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        bindViewModel()
    }
    
    private func addSubviews() {
        contentView.addSubview(photoView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            photo.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            labelStackView.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            labelStackView.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            greenView.heightAnchor.constraint(equalTo: photoView.heightAnchor),
            greenView.widthAnchor.constraint(equalTo: photoView.widthAnchor),
            photoView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    private func bindViewModel() {
        guard let disposeBag = disposeBag else {
            return
        }

        viewModel?.photo
            .drive(photo.rx.image)
            .disposed(by: disposeBag)
    }
}
