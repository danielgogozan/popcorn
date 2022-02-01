//
//  ArtistDetailViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 03.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ArtistDetailViewController: UIViewController {
    
    var onBack: (() -> Void)?
    
    private var viewModel: ArtistCellViewModel
    
    private var disposeBag: DisposeBag

    private lazy var highlightImage: UIImageView = {
        let image = GradientImageView(image: Asset.Images.popcorn.image, colors: [.clear, .clear, Asset.Colors.darkGray.color])
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highlightImage)
        view.addSubview(nameLabel)
        view.addSubview(departmentAndBirthLabel)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        ViewCreator.createLabel(text: "Nina Dobrev", font: FontFamily.AppleGothic.regular.font(size: 30), numberOfLines: 0, textColor: .white)
    }()
    
    private lazy var departmentAndBirthLabel: UILabel = {
        ViewCreator.createLabel(text: "Actress | August 25, 1987", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 0, textColor: .white)
    }()
    
    private lazy var locationLabel: UILabel = {
        ViewCreator.createLabel(text: "Tarzana, Los Angeles, California, USA", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 0, textColor: .black)
    }()
    
    private lazy var biographyLabel: UILabel = {
        ViewCreator.createLabel(text: "biography...", font: FontFamily.AppleGothic.regular.font(size: 14), numberOfLines: 0, textColor: .black)
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Summary", "Movies", "More"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.darkGray.color, NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 16)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.green.color, NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 16)], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var moviesTableView: AutoSizingTableView = {
        let tableView = AutoSizingTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(MovieSearchCell.self, forCellReuseIdentifier: MovieSearchCell.reuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        tableView.separatorColor = .clear
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var summaryView: UIView = {
        let view = UIView()
        view.addSubview(summaryStackView)
        return view
    }()
    
    private var heightSummaryView: NSLayoutConstraint?
    
    private lazy var summaryStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [locationLabel, biographyLabel], axis: .vertical, distribution: .fill, alignment: .fill)
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
        return stackView
    }()
    
    private lazy var albumCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getAlbumCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FirstAlbumCollectionCell.self, forCellWithReuseIdentifier: FirstAlbumCollectionCell.reuseIdentifier)
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
        
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = ViewCreator.createStackView(subviews: [highlightImage, albumCollectionView, segmentedControl, summaryStackView, moviesTableView], axis: .vertical, distribution: .fill, alignment: .fill)
        return stackView
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    init(viewModel: ArtistCellViewModel) {
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
        view.addSubview(nameLabel)
        view.addSubview(departmentAndBirthLabel)
        setupConstraints()
        bindViewModel()
        segmentedControl.addUnderlineForSelectedSegment(width: self.view.bounds.size.width, color: Asset.Colors.green.color)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupNavBar() {
        configureWithTransparentNavBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backChevron.image, style: .plain, target: self,  action: #selector(back(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = Asset.Colors.green.color
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            highlightImage.heightAnchor.constraint(equalToConstant: 500),
            highlightImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: highlightImage.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: departmentAndBirthLabel.topAnchor, constant: -5),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: highlightImage.trailingAnchor, constant: -5),
            departmentAndBirthLabel.leadingAnchor.constraint(equalTo: highlightImage.leadingAnchor, constant: 20),
            departmentAndBirthLabel.bottomAnchor.constraint(equalTo: highlightImage.bottomAnchor, constant: -20),
            departmentAndBirthLabel.trailingAnchor.constraint(lessThanOrEqualTo: highlightImage.trailingAnchor, constant: -5),
        
            albumCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            albumCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        view.addSubview(scrollView)
        scrollView.backgroundColor = Asset.Colors.lightGray.color
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
        viewModel.getMovieCredits()
        viewModel.getProfilePictures()
        disposeBag.insert([
            viewModel.name.drive(nameLabel.rx.text),
            viewModel.departmentAndBirth.drive(departmentAndBirthLabel.rx.text),
            viewModel.location.drive(locationLabel.rx.text),
            viewModel.biography.drive(biographyLabel.rx.text),
            viewModel.poster.drive(highlightImage.rx.image),
            viewModel.movieCredits.drive(moviesTableView.rx.items(cellIdentifier: MovieSearchCell.reuseIdentifier)) { index, movieViewModel, cell in
                guard let cell = cell as? MovieSearchCell else {
                    return
                }
                cell.configure(with: movieViewModel)
            },
            
            viewModel.profiles.drive(albumCollectionView.rx.items) { (collectionView, row, profileViewModel) in
                let indexPath = IndexPath(row: row, section: 0)
                if indexPath.item == 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstAlbumCollectionCell.reuseIdentifier, for: indexPath) as?
                            FirstAlbumCollectionCell else {
                                fatalError("Could not dequeue cell with reuse identifier: \(FirstAlbumCollectionCell.reuseIdentifier)")
                            }
                    cell.configure(with: profileViewModel)
                    return cell
                }
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionCell.reuseIdentifier, for: indexPath) as?
                        AlbumCollectionCell else {
                            fatalError("Could not dequeue cell with reuse identifier: \(AlbumCollectionCell.reuseIdentifier)")
                        }
                cell.configure(with: profileViewModel)
                return cell
            }
        ])
    }
    
    private func getAlbumCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let twoOfFourGroups: [NSCollectionLayoutGroup] = (0..<2).map { _ in
            let twoOfFourItems: [NSCollectionLayoutItem] = (0..<2).map { _ in
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                return item
            }
            let twoOfFourGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            return NSCollectionLayoutGroup.horizontal(layoutSize: twoOfFourGroupSize, subitems: twoOfFourItems)
        }
        
        let fourGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let fourGroup = NSCollectionLayoutGroup.vertical(layoutSize: fourGroupSize, subitems: twoOfFourGroups)
        
        let twoItems: [NSCollectionLayoutItem] = (0..<2).map { _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            return item
        }
        let twoGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let twoGroup = NSCollectionLayoutGroup.horizontal(layoutSize: twoGroupSize, subitems: twoItems)
        
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize, subitems: [twoGroup, fourGroup])
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        return .init(section: section)
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
                self?.moviesTableView.layer.opacity = 0
                self?.moviesTableView.isHidden = true
                self?.summaryStackView.layer.opacity = 1
                self?.summaryStackView.isHidden = false
            }
        case 1:
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.moviesTableView.layer.opacity = 1
                self?.moviesTableView.isHidden = false
                self?.summaryStackView.layer.opacity = 0
                self?.summaryStackView.isHidden = true
            }
        case 2:
            print("More...")
        default:
            print("Default...")
        }
    }
}

extension ArtistDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
}

//class ScaledHeightImageView: UIImageView {
//
//    override var intrinsicContentSize: CGSize {
//
//        if let myImage = self.image {
//            let imageWidth = myImage.size.width
//            let imageHeight = myImage.size.height
//            let viewWidth = self.frame.size.width
//
//            let ratio = viewWidth/imageWidth
//            let scaledHeight = imageHeight * ratio
//
//            return CGSize(width: imageWidth, height: scaledHeight)
//        }
//
//        return CGSize(width: -1.0, height: -1.0)
//    }
//
//}
