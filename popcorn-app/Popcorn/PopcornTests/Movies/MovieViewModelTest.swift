//
//  MovieViewModelTest.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 22.11.2021.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import Popcorn

class MovieViewModelTest: XCTestCase {
    
    private var mockApiService: MockApiService!
    
    private var movieViewModel: MovieViewModel!
    
    private var disposeBag: DisposeBag!
    
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockApiService = MockApiService()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        movieViewModel = nil
        mockApiService = nil
        disposeBag = nil
        try? super.tearDownWithError()
    }
    
    func testDownloadImageOnSuccess() throws {
        let goodMovie = Movie(id: 1, title: "This is the title", posterPath: "poster/path", genreIds: nil, voteAverage: 2, voteCount: 0, duration: 60, genres: [Genre(id: 1, name: "Comedy", poster: nil)])
        mockApiService.responses = [APIUtils.imageBaseUrl + goodMovie.posterPath!: Observable.of(Asset.Images.popcornLandscape.image)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: goodMovie, posterSize: .w154)
        let expectation = XCTestExpectation(description: "Poster should change its value 2 times: on initialization and after the first download is initiatiated within init()")
        expectation.expectedFulfillmentCount = 2
        let observer = scheduler.record(movieViewModel.posterImage, disposeBag: disposeBag)
        movieViewModel.posterImage
            .asObservable()
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        scheduler.start()
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertRecordedElements(observer.events, [Asset.Images.popcorn.image, Asset.Images.popcornLandscape.image])
    }
    
    func testDownloadImageOnError() throws {
        let badMovie = Movie(id: -1, title: "Tityle", posterPath: "", genreIds: nil, voteAverage: -1, voteCount: -1, duration: nil, genres: nil)
        mockApiService.responses = ["": Observable<ApiError>.error(ApiError.fail)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: badMovie, posterSize: .w154)
        let expectation = XCTestExpectation(description: "Since the download will fail, poster should change its value only once: on initialization; and the image should be the default one.")
        let observer = scheduler.record(movieViewModel.posterImage, disposeBag: disposeBag)
        movieViewModel.posterImage
            .asObservable()
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        scheduler.start()
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertRecordedElements(observer.events, [Asset.Images.popcorn.image])
    }
    
    func testMovieTitle() throws {
        let movie = Movie(id: 1, title: "This is the title", posterPath: "poster/path", genreIds: nil, voteAverage: 2, voteCount: 0, duration: 60, genres: [Genre(id: 1, name: "Comedy", poster: nil)])
        let request = RequestFactory.movieDetailRequest(movieId: movie.id)
        mockApiService.responses = [request.path: Observable<Movie>.of(movie)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: movie, posterSize: .w185)
        testDriver(driver: movieViewModel.title, result: ["This is the title"], description: "Get movie title")
    }
    
    func testMovieDuration() throws {
        let movie = Movie(id: 1, title: "This is the title", posterPath: "poster/path", genreIds: nil, voteAverage: 2, voteCount: 0, duration: 60, genres: [Genre(id: 1, name: "Comedy", poster: nil)])
        let request = RequestFactory.movieDetailRequest(movieId: movie.id)
        mockApiService.responses = [request.path: Observable<Movie>.of(movie)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: movie, posterSize: .w185)
        testDriver(driver: movieViewModel.duration, result: ["1 h"], description: "Get movie duration")
    }
    
    
    func testMovieGenre() throws {
        let movie = Movie(id: 1, title: "This is the title", posterPath: "poster/path", genreIds: nil, voteAverage: 2, voteCount: 0, duration: 60, genres: [Genre(id: 1, name: "Comedy", poster: nil)])
        let request = RequestFactory.movieDetailRequest(movieId: movie.id)
        mockApiService.responses = [request.path: Observable<Movie>.of(movie)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: movie, posterSize: .w185)
        testDriver(driver: movieViewModel.genre, result: ["Comedy"], description: "Get movie genres")
    }
    
    
    func testDriver() throws {
        let movie = Movie(id: 1, title: "This is the title", posterPath: "poster/path", genreIds: nil, voteAverage: 2, voteCount: 0, duration: 60, genres: [Genre(id: 1, name: "Comedy", poster: nil)])
        let request = RequestFactory.movieDetailRequest(movieId: movie.id)
        mockApiService.responses = [request.path: Observable<Movie>.of(movie)]
        movieViewModel = MovieViewModel(apiService: mockApiService, movie: movie, posterSize: .w185)
        testDriver(driver: movieViewModel.rating, result: [1], description: "Get movie rating")
    }
    
    func testDriver<T: Equatable>(driver: Driver<T>, result: [T], description: String) {
        let expectation = XCTestExpectation(description: description)
        let observer = scheduler.record(driver, disposeBag: disposeBag)
        driver.asObservable()
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        scheduler.start()
        movieViewModel.getMovieDetails()
        wait(for: [expectation], timeout: 2.0)
        XCTAssertRecordedElements(observer.events, result)
    }
}
