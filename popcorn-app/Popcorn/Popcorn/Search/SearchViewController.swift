//
//  SearchViewController.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewController<T>: UIViewController {
    
    internal let searchViewModel: SearchViewModel<T>
    
    internal lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Asset.Colors.green.color
        activityIndicator.style = .large
        activityIndicator.isHidden = true
        
        return activityIndicator
    }()
    
    internal let disposeBag: DisposeBag
    
    internal var onBack: (() -> Void)?
    
    internal var onSearchError: ((String) -> Void)?
    
    init(viewModel: SearchViewModel<T>) {
        self.searchViewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.lightGray.color
        setupSearchBar()
        bindViews()
    }
    
    internal func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.textField?.textColor = Asset.Colors.green.color
        let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popViewController))
        navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = cancelButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backChevron.image, style: .plain, target: self,  action: #selector(popViewController))
    }
    
    internal func bindViews() {
        searchBar.rx.text.orEmpty
            .bind(to: self.searchViewModel.searchKey)
            .disposed(by: disposeBag)
        
        searchViewModel.loading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        searchViewModel.loading
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        searchViewModel.error
            .asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let self = self,
                      let error = error else {
                          return
                      }
                self.displayAlertMessage(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    internal func bindObservables() {
        fatalError("This method should be implemented by all subclasses.")
    }
    
    @objc func popViewController() {
        onBack?()
    }
    
    internal func displayAlertMessage(message: String) {
        onSearchError?(message)
    }
}
