//
//  AlbumCollectionCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 09.12.2021.
//

import Foundation
import UIKit
import RxSwift

class AlbumCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: AlbumCollectionCell.self)
    
    private var viewModel: ProfileViewModel?
    private var disposeBag: DisposeBag?
    
//    private lazy var photo: ScaledHeightImageView = {
//        let imageView = ViewCreator.createScaledImageView(contentMode: .scaleAspectFit, Asset.Images.popcorn.image)
//        return imageView
//    }()
    
    private lazy var photo: UIImageView = {
        let imageView = ViewCreator.createImageView(contentMode: .scaleToFill, image: Asset.Images.popcorn.image)
        return imageView
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
        disposeBag = nil
    }
    
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        bindViewModel()
    }
    
    private func addSubviews() {
        contentView.addSubview(photo)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            photo.widthAnchor.constraint(equalTo: contentView.widthAnchor),
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
