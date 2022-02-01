//
//  GenreCellViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 23.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class GenreCellViewModel {
    
    private let apiService: APIServiceProtocol
    
    internal let genre: BehaviorRelay<Genre>
    private let posterImage = BehaviorRelay<UIImage>(value: Asset.Images.popcorn.image)
    
    let genreName: Driver<String>
    let poster: Driver<UIImage>
    
    let disposeBag: DisposeBag
    
    init(apiService: APIServiceProtocol, genre: Genre) {
        self.apiService = apiService
        self.genre = BehaviorRelay(value: genre)
        self.genreName = self.genre.map { $0.name }.asDriver(onErrorJustReturn: "unknown")
        self.poster = self.posterImage.asDriver(onErrorJustReturn: Asset.Images.popcorn.image)
        self.disposeBag = DisposeBag()
        downloadGenrePoster()
    }
    
    func downloadGenrePoster() {
        let request = RequestFactory.genrePosterRequest(baseUrl: genre.value.posterPath)
        return apiService.downloadImage(request: request)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] image in
                self?.posterImage.accept(image)
            }
            .disposed(by: disposeBag)
    }
    
}
