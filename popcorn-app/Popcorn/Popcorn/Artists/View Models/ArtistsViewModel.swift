//
//  ArtistViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 26.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

enum ViewModelState<T> {
    case idle
    case loading
    case data(T)
    case error(String)
}

class ArtistsViewModel {
    
    typealias ArtistsDriver = Driver<[ArtistCellViewModel]>
    let noColumns: CGFloat = 3
    let cellSpacing: CGFloat = 10
    
    private let apiService: APIServiceProtocol
    
    private let disposeBag: DisposeBag

    var state: BehaviorRelay<ViewModelState<ArtistsDriver>>
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.disposeBag = DisposeBag()
        self.state = BehaviorRelay(value: .idle)
    }
    
    func getArtists() {
        state.accept(.loading)
        let request = apiService.sendRequest(request: RequestFactory.artistsRequest()) as Observable<Artists>
        request
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] artists in
                guard let self = self else {
                    return
                }
                let associatedViewModels = artists.results.map { ArtistCellViewModel(apiService: self.apiService, artist: $0, posterSize: .w185) }
                self.state.accept(.data(Observable.of(associatedViewModels).asDriver(onErrorJustReturn: [])))
            }, onError: { [weak self] error in
                self?.state.accept(.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}

