//
//  GenreCellViewModelTest.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 06.12.2021.
//

import XCTest
import RxTest
import RxSwift
@testable import Popcorn

class GenreCellViewModelTest: XCTestCase {

    private var mockApiService: MockApiService!
    
    private var genreViewModel: GenreCellViewModel!
    
    private var scheduler: TestScheduler!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockApiService = MockApiService()
        genreViewModel = GenreCellViewModel(apiService: mockApiService, genre: Genre(id:0, name: "", poster: nil))
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
    }

    func testDownloadImageOnSuccess() throws {
        let goodGenre = Genre(id: 1, name: "Action")
        mockApiService.responses = [genrePosters[goodGenre.name]!: Observable.of(Asset.Images.popcornLandscape.image)]
        genreViewModel = GenreCellViewModel(apiService: mockApiService, genre: goodGenre)
        let expectation = XCTestExpectation(description: "Poster should change its value 2 times: on initialization and after the first download is initiatiated within init()")
        expectation.expectedFulfillmentCount = 2
        let observer = scheduler.record(genreViewModel.poster, disposeBag: disposeBag)
        genreViewModel.poster
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
        let badGenre = Genre(id: -1, name: "Comedy")
        mockApiService.responses = [genrePosters[badGenre.name]!: Observable<ApiError>.error(ApiError.fail)]
        genreViewModel = GenreCellViewModel(apiService: mockApiService, genre: badGenre)
        let expectation = XCTestExpectation(description: "Since the download will fail, poster should change its value only once: on initialization; and the image should be the default one.")
        let observer = scheduler.record(genreViewModel.poster, disposeBag: disposeBag)
        genreViewModel.poster
            .asObservable()
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        scheduler.start()
        wait(for: [expectation], timeout: 2.0)
        XCTAssertRecordedElements(observer.events, [Asset.Images.popcorn.image])
    }

}
