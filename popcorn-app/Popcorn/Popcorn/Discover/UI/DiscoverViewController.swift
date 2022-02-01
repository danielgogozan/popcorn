//
//  DiscoverViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit
import RxSwift

class DiscoverViewController: SearchableViewController {
    
    private var viewModel: DiscoverViewModel
    
    private lazy var colectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //let layout = CustomFLowLayout(widthPercent: 0.3, heightPercent: 1)
        layout.scrollDirection = .vertical
       // layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.reuseIdentifier)
        collectionView.register(DiscoverCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscoverCollectionHeader.reuseIdentifier)
        
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.lightGray.color
        navigationItem.title = L10n.discoverSection
        
        addSubviews(views: [self.colectionView])
        setupConstraints()
        viewModel.getMovies()
        bindViewModel()
    }
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.sectionToReload.subscribe(onNext: { section in
            guard let section = section else {
                return
            }
            DispatchQueue.main.async {
                self.colectionView.reloadSections(IndexSet(integer: section))
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.colectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.colectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.colectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            self.colectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.noSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.reuseIdentifier, for: indexPath) as? MoviesCollectionViewCell else {
            fatalError("Could not dequeue MoviesCollectionViewCell")
        }
        
        cell.configure(movieViewModels: viewModel.getViewModelsBySection(section: indexPath.section))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiscoverCollectionHeader.reuseIdentifier, for: indexPath) as? DiscoverCollectionHeader,
              let sectionName = MovieSection(rawValue: indexPath.section)?.name else {
                  fatalError("Unable to dequeue collection header.")
              }
        header.configure(sectionName: sectionName)
        return header
    }
    
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let space = (layout?.sectionInset.left ?? 0) + (layout?.sectionInset.right ?? 0)
        return CGSize(width: view.frame.width - space, height: 268)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.05)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.03)
        }
    }
}
