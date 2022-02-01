//
//  MovieDetailViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import UIKit
import RxSwift
import RxAnimated

class MovieDetailViewController: UIViewController {
    
    var onBack: (() -> Void)?
    private let viewModel: MovieViewModel
    private let disposeBag: DisposeBag
    
    private lazy var highlightView: HighlightMovieDetailView = {
        let view = HighlightMovieDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieDetailsView: MovieDetailsView = {
        let view = MovieDetailsView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Cast", "Reviews", "More"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.darkGray.color,
                                                 NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 16)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.green.color,
                                                 NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 16)], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var collectionView: AutoSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var collectionView = AutoSizingCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Asset.Colors.lightGray.color
        collectionView.delegate = self
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var reviewTableView: AutoSizingTableView = {
        let tableView = AutoSizingTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.Colors.lightGray.color
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return tableView
    }()
    
    private lazy var similarMoviesTableView: AutoSizingTableView = {
        let tableView = AutoSizingTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.Colors.lightGray.color
        tableView.register(MovieSearchCell.self, forCellReuseIdentifier: MovieSearchCell.reuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return tableView
    }()
    
    private lazy var infoLabel: UILabel = {
        ViewCreator.createLabel(text: "This movie has no reviews.",
                                font: FontFamily.AppleGothic.regular.font(size: 15),
                                numberOfLines: 0,
                                textColor: .black)
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [infoLabel],
                                                    axis: .vertical,
                                                    distribution: .fill,
                                                    alignment: .center)
        stackView.isHidden = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        return ViewCreator.createStackView(subviews: [highlightView, movieDetailsView, segmentedControl, collectionView, reviewTableView, similarMoviesTableView,
                                                      infoStackView],
                                           axis: .vertical,
                                           distribution: .fill,
                                           alignment: .fill)
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupScrollView()
        setupConstraints()
        bindViewModel()
        segmentedControl.addUnderlineForSelectedSegment(width: self.view.bounds.size.width, color: Asset.Colors.green.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = Asset.Colors.green.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupNavBar() {
        configureWithTransparentNavBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backChevron.image, style: .plain, target: self,
                                                           action: #selector(back(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.Images.more.image, style: .plain, target: nil, action: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            highlightView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            highlightView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            highlightView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            highlightView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func bindViewModel() {
        viewModel.getCast()
        viewModel.getReviews()
        viewModel.getSimilarMovies()
        disposeBag.insert([
            viewModel.posterImage.asObservable().subscribe(onNext: { [weak self] image in
                self?.highlightView.configure(with: image)
            }),
            
            viewModel.cast.drive(collectionView.rx.items(cellIdentifier: ArtistCell.reuseIdentifier)) { index, viewModel, cell in
                guard let cell = cell as? ArtistCell else {
                    return
                }
                cell.configure(viewModel: viewModel)
            },
            
            viewModel.reviews.drive(reviewTableView.rx.items(cellIdentifier: ReviewCell.reuseIdentifier)) { [weak self] index, viewModel, cell in
                guard let cell = cell as? ReviewCell,
                      let self = self else {
                    return
                }
                cell.configure(viewModel: viewModel) {
                    self.expandTableViewRow(for: index, with: viewModel)
                }
            },
            
            viewModel.similarMovies.drive(similarMoviesTableView.rx.items(cellIdentifier: MovieSearchCell.reuseIdentifier)) { index, viewModel, cell in
                guard let cell = cell as? MovieSearchCell else {
                    return
                }
                cell.configure(with: viewModel)
            }
        ])
    }
    
    @objc func back(_ sender: UIButton) {
        onBack?()
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl!)
    {
        self.segmentedControl.changeUnderlinePosition()
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else {
                    return
                }
                self.reviewTableView.hide()
                self.similarMoviesTableView.hide()
                self.collectionView.isHidden = false
            }
            if viewModel.isCastEmpty() {
                infoStackView.isHidden = false
                infoLabel.text = "This movie has no cast available."
            } else {
                infoStackView.isHidden = true
            }
        case 1:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else {
                    return
                }
                self.collectionView.hide()
                self.similarMoviesTableView.hide()
                self.reviewTableView.isHidden = false
            }
            if viewModel.areReviewsEmpty() {
                infoStackView.isHidden = false
                infoLabel.text = "This movie has no reviews yet."
            } else {
                infoStackView.isHidden = true
            }
        case 2:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else {
                    return
                }
                self.collectionView.hide()
                self.reviewTableView.hide()
                self.similarMoviesTableView.isHidden = false
            }
            if viewModel.areSimilarMoviesEmpty() {
                infoStackView.isHidden = false
                infoLabel.text = "This movie has no similar movies."
            } else {
                infoStackView.isHidden = true
            }
        default:
            print("Default...")
        }
    }
    
    private func expandTableViewRow(for row: Int, with viewModel: ReviewCellViewModel) {
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = reviewTableView.cellForRow(at: indexPath) as? ReviewCell else {
            return
        }
        reviewTableView.beginUpdates()
        viewModel.isExpanded.toggle()
        cell.configure(viewModel: viewModel) { [weak self] in
            self?.expandTableViewRow(for: row, with: viewModel)
        }
        reviewTableView.endUpdates()
        reviewTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGFloat = 100
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let space = layout.sectionInset.left + layout.sectionInset.right + (viewModel.noColumns * viewModel.cellSpacing - 1)
            cellSize = (view.frame.width - space) / viewModel.noColumns
        }
        return CGSize(width: cellSize, height: cellSize * 1.8)
    }
}
