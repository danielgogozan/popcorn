//
//  MovieViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 18.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    let noColumns: CGFloat = 3
    let cellSpacing: CGFloat = 10
    
    private var apiService: APIServiceProtocol
    private var disposeBag: DisposeBag
    let dateFormatter: DateFormatter
    
    private var movie: BehaviorRelay<Movie>
    private var posterBehaviorRelay: BehaviorRelay<UIImage>
    private var castBehaviorRelay: BehaviorRelay<[ArtistCellViewModel]>
    private var reviewsBehaviorRelay: BehaviorRelay<[ReviewCellViewModel]>
    private var similarMoviesBehaviorRelay: BehaviorRelay<[MovieViewModel]>
    
    let posterImage: Driver<UIImage>
    let title: Driver<String>
    lazy var duration: Driver<String> = {
        self.movie.map { [weak self] _ in self?.getRuntime() ?? "" }.asDriver(onErrorJustReturn: "")
    }()
    lazy var releaseAndRuntime: Driver<String> = {
        self.movie.map { [weak self] _ in self?.getReleaseAndRuntime() ?? "" }.asDriver(onErrorJustReturn: "")
    }()
    let genre: Driver<String>
    let rating: Driver<Rating>
    let explicitRating: Driver<String>
    let language: Driver<String>
    let overview: Driver<String>
    var cast: Driver<[ArtistCellViewModel]> {
        castBehaviorRelay.asDriver(onErrorJustReturn: [])
    }
    var reviews: Driver<[ReviewCellViewModel]> {
        reviewsBehaviorRelay.asDriver(onErrorJustReturn: [])
    }
    var similarMovies: Driver<[MovieViewModel]> {
        similarMoviesBehaviorRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(apiService: APIServiceProtocol, movie: Movie, posterSize: APIUtils.PosterSize, dateFormatter: DateFormatter = DateUtils.defaultDateFormatter()) {
        self.apiService = apiService
        self.dateFormatter = dateFormatter
        self.movie = BehaviorRelay(value: movie)
        self.castBehaviorRelay = BehaviorRelay(value: [])
        self.reviewsBehaviorRelay = BehaviorRelay(value: [])
        self.similarMoviesBehaviorRelay = BehaviorRelay(value: [])
        self.posterBehaviorRelay = BehaviorRelay(value: Asset.Images.popcorn.image)
        self.title = self.movie.map { $0.title }.asDriver(onErrorJustReturn: "")
        self.genre = self.movie.map { $0.genreString }.asDriver(onErrorJustReturn: "")
        self.rating = self.movie.map { Rating(totalFilled: $0.rating) }.asDriver(onErrorJustReturn: Rating(totalFilled: 0))
        self.explicitRating = self.movie.map { $0.explicitRating }.asDriver(onErrorJustReturn: "")
        self.language = self.movie.map { "Language: \($0.language)" }.asDriver(onErrorJustReturn: "")
        self.overview = self.movie.map { $0.overview ?? "" }.asDriver(onErrorJustReturn: "")
        self.posterImage = self.posterBehaviorRelay.asDriver(onErrorJustReturn: Asset.Images.popcorn.image)
        self.disposeBag = DisposeBag()
        
        getMovieDetails()
        downloadPoster(size: posterSize)
    }
    
    func downloadPoster(size: APIUtils.PosterSize) {
        guard let path = movie.value.posterPath,
              posterBehaviorRelay.value == Asset.Images.popcorn.image else {
            return
        }
        let request = RequestFactory.moviePosterRequest(path: path, size: size.rawValue)
        apiService.downloadImage(request: request)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] image in
                self?.posterBehaviorRelay.accept(image)
            }
            .disposed(by: disposeBag)
    }
    
    func getMovieDetails() {
        let request = RequestFactory.movieDetailRequest(movieId: movie.value.id)
        let movie = apiService.sendRequest(request: request) as Observable<Movie>
        movie
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] movie in
                self?.movie.accept(movie)
            })
            .disposed(by: disposeBag)
    }
    
    func getCast() {
        let request = RequestFactory.castRequest(movieId: movie.value.id)
        let castObs = apiService.sendRequest(request: request) as Observable<Cast>
        castObs
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }
                let associatedViewModels = result.cast.map { ArtistCellViewModel(apiService: self.apiService, artist: $0, posterSize: .w185) }
                self.castBehaviorRelay.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    func getReviews() {
        let request = RequestFactory.reviewsRequest(movieId: movie.value.id)
        let castObs = apiService.sendRequest(request: request) as Observable<Reviews>
        castObs
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] reviews in
                guard let self = self else {
                    return
                }
                let associatedViewModels = reviews.results.map { ReviewCellViewModel(apiService: self.apiService, review: $0) }
                self.reviewsBehaviorRelay.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    func getSimilarMovies() {
        let request = RequestFactory.similarMoviesRequest(movieId: movie.value.id)
        let similarMoviesObs = apiService.sendRequest(request: request) as Observable<Movies>
        similarMoviesObs
            .observeOn(MainScheduler.asyncInstance)
            .subscribe (onNext: { [weak self] movies in
                guard let self = self else {
                    return
                }
                let associatedViewModels = movies.results.map { MovieViewModel(apiService: self.apiService, movie: $0, posterSize: .w154) }
                self.similarMoviesBehaviorRelay.accept(associatedViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    func areReviewsEmpty() -> Bool {
        return reviewsBehaviorRelay.value.isEmpty
    }
    
    func isCastEmpty() -> Bool {
        return castBehaviorRelay.value.isEmpty
    }
    
    func areSimilarMoviesEmpty() -> Bool {
        return similarMoviesBehaviorRelay.value.isEmpty
    }
    
    private func getReleaseAndRuntime() -> String {
        guard let releaseDate = movie.value.releaseDate,
              let date = dateFormatter.date(from: releaseDate) else {
            return ""
        }
        dateFormatter.dateStyle = .medium
        let prettyReleaseDate = dateFormatter.string(from: date)
        
        if movie.value.productionCountries?.isEmpty ?? true {
            return "\(prettyReleaseDate), \(getRuntime())"
        }
        else {
            return prettyReleaseDate + " (\(movie.value.productionCountries?[0].name ?? "")) " + getRuntime()
        }
    }
    
    private func getRuntime() -> String {
        guard let duration = movie.value.duration else {
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        // e.g 1hr, 25min
        formatter.unitsStyle = .short
        return formatter.string(from: TimeInterval(duration * 60))!.replacingOccurrences(of: "hr", with: "h").replacingOccurrences(of: "min", with: "mins")
    }
}
