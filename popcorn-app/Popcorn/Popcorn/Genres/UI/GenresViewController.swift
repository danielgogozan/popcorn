//
//  GenresViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 16.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class GenresViewController: SearchableViewController {

    private let viewModel: GenreViewModel
    
    private let disposeBag: DisposeBag
    
    private lazy var tableView: CustomTableView = {
        let tableView = CustomTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(GenreCell.self, forCellReuseIdentifier: GenreCell.reuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        return tableView
    }()
    
    init(viewModel: GenreViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Genres"
        view.addSubview(tableView)
        setupConstraints()
        viewModel.getGenres()
        bindViews()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func bindViews() {
        viewModel.genre.drive(tableView.rx.items(cellIdentifier: GenreCell.reuseIdentifier)) { (_, viewModel, cell) in
            guard let cell = cell as? GenreCell else {
                return
            }
            cell.configure(viewModel: viewModel)
        }
        .disposed(by: disposeBag)
    }
}
