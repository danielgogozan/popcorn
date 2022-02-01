//
//  ArtistsViewModelTest.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 06.12.2021.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import Popcorn

class ArtistsViewModelTest: XCTestCase {
    
    private var mockApiService: MockApiService!
    
    private var artistViewModel: ArtistsViewModel!
    
    private let artist = Artist(id: 1, name: "Name", profilePath: nil, poster: nil)
    
    private var artists: Artists!
    
    private var scheduler: TestScheduler!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        mockApiService = MockApiService()
        artists = Artists(results: [artist, artist, artist])
        artistViewModel = ArtistsViewModel(apiService: mockApiService)
        scheduler = TestScheduler(initialClock: 0, resolution: 1)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        disposeBag = nil
    }
    
    func testGetArtistsOnSuccess() throws {
        mockApiService.responses = [RequestFactory.artistsRequest().path: Observable<Artists>.of(artists)]
        let expectation = XCTestExpectation(description: "Get artists on success")
        expectation.expectedFulfillmentCount = 3
        let observer = scheduler.record(artistViewModel.state, disposeBag: disposeBag)
        artistViewModel.state.subscribe(onNext: { result in
            switch result {
            case .idle:
                expectation.fulfill()
            case .data(_):
                expectation.fulfill()
            case .loading:
                expectation.fulfill()
            case .error(_):
                XCTFail("No error is expected in case of receiving data successfully.")
            }
        })
            .disposed(by: disposeBag)
        scheduler.start()
        artistViewModel.getArtists()
        wait(for: [expectation], timeout: 2.0)
        XCTAssert(observer.events.count == 3)
    }
    
    func testGetArtistsOnError() throws {
        mockApiService.responses = [RequestFactory.artistsRequest().path: Observable<ApiError>.error(ApiError.fail)]
        let expectation = XCTestExpectation(description: "Get artists on success")
        expectation.expectedFulfillmentCount = 3
        let observer = scheduler.record(artistViewModel.state, disposeBag: disposeBag)
        artistViewModel.state.subscribe(onNext: { result in
            switch result {
            case .idle:
                expectation.fulfill()
            case .data(_):
                XCTFail("No data is expected in case of error.")
            case .loading:
                expectation.fulfill()
            case .error(_):
                expectation.fulfill()
            }
        })
            .disposed(by: disposeBag)
        scheduler.start()
        artistViewModel.getArtists()
        wait(for: [expectation], timeout: 2.0)
        XCTAssert(observer.events.count == 3)
    }
    
}
