//
//  ArtistsViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit
import RxSwift

class ArtistsViewController: SearchableViewController {
    
    var onDetail: ((ArtistCellViewModel) -> ())?
    
    private let viewModel: ArtistsViewModel
    
    private let disposeBag: DisposeBag
    
    internal var onError: ((String) -> Void)?
    
    private var artistViewModels: [ArtistCellViewModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseIdentifier)
        
        return collectionView
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Asset.Colors.green.color
        activityIndicator.style = .large
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    init(viewModel: ArtistsViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.lightGray.color
        navigationItem.title = "Artists"
        addSubviews(views: [collectionView, activityIndicator])
        setupConstraints()
        bindViewModel()
        viewModel.getArtists()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .idle:
                break;
            case .loading:
                self.activityIndicator.startLoading()
                
            case .data(let viewModels):
                self.activityIndicator.stopLoading()
                viewModels.drive(self.collectionView.rx.items(cellIdentifier: ArtistCell.reuseIdentifier)) { index, viewModel, cell in
                    guard let cell = cell as? ArtistCell else {
                        return
                    }
                    cell.configure(viewModel: viewModel)
                }
                .disposed(by: self.disposeBag)
                
                viewModels.asObservable().subscribe { result in
                    self.artistViewModels = result
                }
                .disposed(by: self.disposeBag)
                
            case .error(let error):
                self.activityIndicator.stopLoading()
                self.onError?(error)
            }
        })
            .disposed(by: disposeBag)
    }
    
    func retry() {
        viewModel.getArtists()
    }
}

extension ArtistsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGFloat = 100
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let space = layout.sectionInset.left + layout.sectionInset.right + (viewModel.noColumns * viewModel.cellSpacing - 1)
            cellSize = (view.frame.width - space) / viewModel.noColumns
        }
        return CGSize(width: cellSize, height: cellSize * 1.8)
    }
}


extension ArtistsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let associatedViewModel = self.artistViewModels[indexPath.row]
        onDetail?(associatedViewModel)
    }
}
