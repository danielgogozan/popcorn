//
//  GenreCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 23.11.2021.
//

import Foundation
import UIKit
import RxSwift

class GenreCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: GenreCell.self)
    
    private var viewModel: GenreCellViewModel?
    
    private var disposeBag: DisposeBag?
    
    private lazy var genreImageView: UIImageView = {
        ViewCreator.createImageView(contentMode: .scaleToFill, image: Asset.Images.popcornLandscape.image)
    }()
    
    private lazy var genreLabel: UILabel = {
        ViewCreator.createLabel(text: "Genre", font: FontFamily.AppleGothic.regular.font(size: 22), textColor: Asset.Colors.dark.color)
    }()
    
    private lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        whiteView.layer.opacity = 0.65
        return whiteView
    }()
    
    private lazy var spaceView: UIView = {
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.backgroundColor = .white
        return spaceView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutMargins = .zero
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
        genreImageView.image = nil
    }
    
    func configure(viewModel: GenreCellViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        bindViews()
    }
    
    private func addSubviews() {
        contentView.addSubview(genreImageView)
        contentView.addSubview(whiteView)
        contentView.addSubview(genreLabel)
        contentView.addSubview(spaceView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            genreImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            genreImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            genreImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            genreImageView.heightAnchor.constraint(equalToConstant: 200),
            
            whiteView.bottomAnchor.constraint(equalTo: spaceView.topAnchor),
            whiteView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            whiteView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 50),
            
            spaceView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            spaceView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            spaceView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            spaceView.heightAnchor.constraint(equalToConstant: 8),
            
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor)
            
        ])
    }
    
    private func bindViews() {
        guard let disposeBag = disposeBag else {
            return
        }

        viewModel?.poster
            .drive(genreImageView.rx.animated.fade(duration: 0.5).image)
            .disposed(by: disposeBag)
        
        viewModel?.genreName
            .drive(genreLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
