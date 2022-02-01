//
//  ArtistCellViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 26.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class ArtistCellViewModel {
    
    private let apiService: APIServiceProtocol
    
    internal let artist: BehaviorRelay<Artist>
    private let posterImage = BehaviorRelay<UIImage>(value: Asset.Images.popcorn.image)
    private let moviesBehaviorRelay: BehaviorRelay<[MovieViewModel]>
    private let profilesBehaviorRelay: BehaviorRelay<[ProfileViewModel]>
    
    let name: Driver<String>
    let poster: Driver<UIImage>
    let departmentAndBirth: Driver<String>
    let location: Driver<String?>
    let biography: Driver<String?>
    let movieCredits: Driver<[MovieViewModel]>
    let profiles: Driver<[ProfileViewModel]>
    
    let disposeBag: DisposeBag
    
    init(apiService: APIServiceProtocol, artist: Artist, posterSize: APIUtils.ProfileSize) {
        self.apiService = apiService
        self.artist = BehaviorRelay(value: artist)
        self.name = self.artist.map { $0.name }.asDriver(onErrorJustReturn: "unknown")
        self.poster = self.posterImage.asDriver(onErrorJustReturn: Asset.Images.popcorn.image)
        self.profilesBehaviorRelay = BehaviorRelay(value: [])
        self.moviesBehaviorRelay = BehaviorRelay(value: [])
        self.departmentAndBirth = self.artist.map { $0.departmentAndBirth }.asDriver(onErrorJustReturn: "")
        self.location = self.artist.map { $0.placeOfBirth }.asDriver(onErrorJustReturn: "")
        self.biography = self.artist.map { $0.biography }.asDriver(onErrorJustReturn: "")
        self.movieCredits = self.moviesBehaviorRelay.asDriver(onErrorJustReturn: [])
        self.profiles = self.profilesBehaviorRelay.asDriver(onErrorJustReturn: [])
        self.disposeBag = DisposeBag()
        
        getArtisDetails()
        downloadArtistPoster(size: posterSize)
    }
    
    func downloadArtistPoster(size: APIUtils.ProfileSize) {
        let request = RequestFactory.artistPoster(path: artist.value.profilePath, size: size.rawValue)
        return apiService.downloadImage(request: request)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] image in
                self?.posterImage.accept(image)
            }
            .disposed(by: disposeBag)
    }
    
    func getArtisDetails() {
        let request = apiService.sendRequest(request: RequestFactory.artistDetailRequest(artistId: artist.value.id)) as Observable<Artist>
        request
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] artist in
                self?.artist.accept(artist)
            }
            .disposed(by: disposeBag)
    }
    
    func getMovieCredits() {
        let request = apiService.sendRequest(request: RequestFactory.movieCreditsRequest(artistId: artist.value.id)) as Observable<MovieCredits>
        request
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] movieCredits in
                guard let self = self else {
                    return
                }
                let associatedViewModels = movieCredits.cast.map { MovieViewModel(apiService: self.apiService, movie: $0, posterSize: .w185) }
                self.moviesBehaviorRelay.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    func getProfilePictures() {
        let request = apiService.sendRequest(request: RequestFactory.profileRequest(artistId: artist.value.id)) as Observable<Profiles>
        request
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }
                let limit = result.profiles.count < 6 ? result.profiles.count : 6
                let associatedViewModels = result.profiles[0..<limit].map { ProfileViewModel(apiService: self.apiService, profile: $0, size: .w185) }
                self.profilesBehaviorRelay.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
}
