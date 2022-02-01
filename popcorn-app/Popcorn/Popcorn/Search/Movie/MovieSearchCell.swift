//
//  MovieSearchCellTableViewCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxAnimated

class MovieSearchCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MovieSearchCell.self)
    
    private var movieViewModel: MovieViewModel?
    
    private var disposeBag: DisposeBag?
    
    private lazy var posterImageView: UIImageView = {
        ViewCreator.createImageView(contentMode: .scaleAspectFill, image: Asset.Images.popcornLandscape.image)
    }()
    
    private lazy var titleLabel: UILabel = {
        ViewCreator.createLabel(text: "Title", font: FontFamily.AppleGothic.regular.font(size: 18), numberOfLines: 1, textColor: Asset.Colors.black.color)
    }()
    
    private lazy var genresLabel: UILabel = {
        ViewCreator.createLabel(text: "Title", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 1, textColor: Asset.Colors.darkGray.color)
    }()
    
    private lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    private lazy var spaceView: UIView = {
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.backgroundColor = Asset.Colors.lightGray.color
        return spaceView
    }()
    
    private lazy var ratingView: StarRatingView = {
        let view = StarRatingView(withLabel: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        ratingView.reset()
        posterImageView.image = nil
    }
    
    func configure(with movieViewModel: MovieViewModel) {
        self.disposeBag = DisposeBag()
        self.movieViewModel = movieViewModel
        bindObservables()
    }
    
    func bindObservables() {
        guard let disposeBag = disposeBag else {
            return
        }
        
        self.movieViewModel?.posterImage
            .drive(posterImageView.rx.animated.fade(duration: 0.3).image)
            .disposed(by: disposeBag)
        
        self.movieViewModel?.title.drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        self.movieViewModel?.genre.drive(self.genresLabel.rx.text).disposed(by: disposeBag)
        self.movieViewModel?.rating.asObservable()
            .subscribe(onNext: { [weak self] rating in
                self?.ratingView.configure(with: rating)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupContentView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 2.5
        contentView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(posterImageView)
        whiteView.addSubview(ratingView)
        whiteView.addSubview(titleLabel)
        whiteView.addSubview(genresLabel)
        contentView.addSubview(whiteView)
        contentView.addSubview(spaceView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 170),
            posterImageView.bottomAnchor.constraint(equalTo: whiteView.topAnchor),
            
            whiteView.heightAnchor.constraint(equalToConstant: 60),
            whiteView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            whiteView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            whiteView.bottomAnchor.constraint(equalTo: spaceView.topAnchor),
            
            spaceView.heightAnchor.constraint(equalToConstant: 15),
            spaceView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            spaceView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            spaceView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: whiteView.leftAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: genresLabel.topAnchor, constant: -5),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: whiteView.topAnchor),

            genresLabel.leftAnchor.constraint(equalTo: whiteView.leftAnchor, constant: 5),
            genresLabel.rightAnchor.constraint(equalTo: whiteView.rightAnchor, constant: -5),
            genresLabel.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -5),

            ratingView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 5),
            ratingView.rightAnchor.constraint(equalTo: whiteView.rightAnchor, constant: -5),
            ratingView.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 5),
            ratingView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}
