//
//  DiscoverViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class DiscoverViewModel: SearchViewModel<MovieViewModel> {
    
    private var apiService: APIServiceProtocol
    
    var movieViewModels = BehaviorRelay<[MovieSection : [MovieViewModel]]>(value: [:])
    
    var sectionToReload = BehaviorRelay<Int?>(value: nil)
    
    let noSections = MovieSection.allCases.count
    
    private let disposeBag = DisposeBag()
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getViewModelsBySection(section: Int) -> [MovieViewModel] {
        guard let movieSection = MovieSection(rawValue: section) else {
            return []
        }
        
        return movieViewModels.value[movieSection] ?? []
    }
    
    func getMovies() {
        for i in 0..<MovieSection.allCases.count {
            if  let movieSection = MovieSection.init(rawValue: i) {
                let moviesObs = apiService.sendRequest(request: movieSection.apiRequest) as Observable<Movies>
                moviesObs
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe (onNext: { [weak self] movies in
                        guard let self = self else {
                            return
                        }
                        let viewModels = movies.results.map { MovieViewModel(apiService: self.apiService, movie: $0, posterSize: .w154) }
                        self.movieViewModels.accept(self.movieViewModels.value + [movieSection : viewModels])
                        self.sectionToReload.accept(movieSection.rawValue)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    override func search(byKey key: String) -> Observable<[MovieViewModel]> {
        let searchRequest = apiService.sendRequest(request: RequestFactory.searchMovieRequest(searchKey: key)) as Observable<Movies>
        return searchRequest
            .observeOn(MainScheduler.asyncInstance)
            .flatMap { movies -> Observable<[MovieViewModel]> in
                return Observable<[MovieViewModel]>.create { observer -> (Disposable) in
                    if movies.results.isEmpty {
                        observer.onError(SearchError.notFound)
                    } else {
                        let associatedViewModels = movies.results.map { MovieViewModel(apiService: self.apiService, movie: $0, posterSize: .w500) }
                        observer.onNext(associatedViewModels)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
    }
    
}
