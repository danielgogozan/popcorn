//
//  MoviesCollectionViewCell.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MoviesCollectionViewCell.self)
    
    private var movieViewModels: [MovieViewModel] = []
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movieViewModels: [MovieViewModel]) {
        self.movieViewModels = movieViewModels
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}

extension MoviesCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            fatalError("Could not dequeue MovieCell")
        }
        
        cell.configure(movieViewModel: movieViewModels[indexPath.item])
        return cell
    }
}

extension MoviesCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 228)
    }
    
}
