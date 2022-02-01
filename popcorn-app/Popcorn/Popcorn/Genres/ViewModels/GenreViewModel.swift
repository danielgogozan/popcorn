//
//  GenreViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 22.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class GenreViewModel {
    
    private var apiService: APIServiceProtocol
    
    private let disposeBag = DisposeBag()
    
    private let _genres = BehaviorRelay<[GenreCellViewModel]>(value: [])
    
    var genre: Driver<[GenreCellViewModel]> {
        return _genres.asDriver(onErrorJustReturn: [])
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getGenres() {
        let request = apiService.sendRequest(request: RequestFactory.genresRequest()) as Observable<Genres>
        request
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] genres in
                guard let self = self else {
                    return
                }
                let associatedViewModels = genres.genres.map { GenreCellViewModel(apiService: self.apiService, genre: $0) }
                self._genres.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
}
