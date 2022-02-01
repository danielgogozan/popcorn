//
//  SearchViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 19.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel<T> {
    
    private let disposeBag = DisposeBag()
    
    // MARK: -ERROR
    enum SearchError: Error {
        case notFound
        case unknown
        case base(Error)
    }
    
    // MARK: -INPUTS - observables
    private let _searchKey = PublishSubject<String>()
    private let _loading = PublishSubject<Bool>()
    private let _error = PublishSubject<SearchError?>()
    private let _result = PublishSubject<[T]>()
    
    //MARK: -OUTPUTS - observers
    var searchKey: AnyObserver<String> {
        return _searchKey.asObserver()
    }
    
    var loading: Driver<Bool> {
        return _loading.asDriver(onErrorJustReturn: false)
    }
    
    var error: Driver<SearchError?> {
        return _error.asDriver(onErrorJustReturn: SearchError.unknown)
    }
    
    var result: Driver<[T]> {
        return _result.asDriver(onErrorJustReturn: [])
    }
    
    init() {
        _searchKey
            .asObservable()
            .filter { !$0.isEmpty }
            .debounce(DispatchTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] key -> Observable<[T]> in
                guard let self = self else {
                    return Observable.empty()
                }
                // hide error
                self._error.onNext(nil)
                // begin loading
                self._loading.onNext(true)
                return self.search(byKey: key)
                    .catchError { error in
                        print("[SearchViewModel] search on error \(error)")
                        self._error.onNext(SearchError.base(error))
                        self._loading.onNext(false)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] results in
                self?._loading.onNext(false)
                if results.isEmpty {
                    self?._error.onNext(SearchError.notFound)
                }
                else {
                    self?._result.onNext(results)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: -METHODS THAT MUST BE IMPLEMENTED
    
    func search(byKey key: String) -> Observable<[T]> {
        fatalError("This method should be implemented by all subclasses.")
    }
    
}
