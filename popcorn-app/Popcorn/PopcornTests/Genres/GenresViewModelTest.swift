//
//  GenresViewModelTest.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 06.12.2021.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import Popcorn
import WebKit

class GenresViewModelTest: XCTestCase {

    private var mockApiService: MockApiService!
    
    private var genreViewModel: GenreViewModel!
    
    private let genre = Genre(id: 1, name: "g")
    
    private var genreCellViewModel: GenreCellViewModel!
    
    private var associatedViewModels: [GenreCellViewModel]!
    
    private var genres: Genres!
    
    private var scheduler: TestScheduler!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockApiService = MockApiService()
        genreCellViewModel = GenreCellViewModel(apiService: mockApiService, genre: genre)
        associatedViewModels = [genreCellViewModel, genreCellViewModel, genreCellViewModel]
        genres = Genres(genres: [genre, genre, genre])
        genreViewModel = GenreViewModel(apiService: mockApiService)
        scheduler = TestScheduler(initialClock: 0, resolution: 1)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        disposeBag = nil
    }

    func testGetGenresOnSuccess() throws {
        mockApiService.responses = [ RequestFactory.genresRequest().path: Observable<Genres>.of(genres)]
        let expectation = XCTestExpectation(description: "Genre not nil")
        // record of the values from vm
        let observer = scheduler.record(genreViewModel.genre, disposeBag: disposeBag)
        // wait for receiving a non empty array
        genreViewModel.genre
            .filter { !$0.isEmpty }
            .asObservable()
            .subscribe(onNext: { result in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        // start the scheduler
        scheduler.start()
        // trigger input
        genreViewModel.getGenres()
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertRecordedElements(observer.events, [[], associatedViewModels])
    }
    
    func testGetGenresOnError() throws {
        let expectation = XCTestExpectation(description: "Genres is [] on error.")
        mockApiService.responses = [ RequestFactory.genresRequest().path: Observable<ApiError>.error(ApiError.fail)]
        let observer = scheduler.record(genreViewModel.genre, disposeBag: disposeBag)
        genreViewModel.genre.asObservable().subscribe(onNext: { genres in
            if genres.isEmpty {
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        scheduler.start()
        genreViewModel.getGenres()
        wait(for: [expectation], timeout: 2.0)
        XCTAssertRecordedElements(observer.events, [[]])
    }
}

