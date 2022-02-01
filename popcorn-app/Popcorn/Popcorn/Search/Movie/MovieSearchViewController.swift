//
//  MovieSearchViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieSearchViewController: SearchViewController<MovieViewModel> {
    
    var onDetail: ((MovieViewModel) -> ())?
    
    private var movieViewModels: [MovieViewModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(MovieSearchCell.self, forCellReuseIdentifier: MovieSearchCell.reuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.preservesSuperviewLayoutMargins = true
        tableView.directionalLayoutMargins = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews(views: [tableView, activityIndicator])
        setupConstraints()
        viewRespectsSystemMinimumLayoutMargins = false
        view.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent != nil {
            bindObservables()
        }
    }
    
    override func bindObservables() {
        self.searchViewModel.result.drive(tableView.rx.items(cellIdentifier: MovieSearchCell.reuseIdentifier)) { (index, movieViewModel: MovieViewModel, cell) in
            DispatchQueue.main.async {
                guard let cell = cell as? MovieSearchCell else {
                    return
                }
                cell.configure(with: movieViewModel)
                cell.preservesSuperviewLayoutMargins = true
                cell.contentView.preservesSuperviewLayoutMargins = true
            }
        }
        .disposed(by: disposeBag)
        
        self.searchViewModel.result.asObservable().subscribe(onNext: { [weak self] viewModels in
            self?.movieViewModels = viewModels
        })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let associatedViewModel = self.movieViewModels[indexPath.row]
        onDetail?(associatedViewModel)
    }
}
