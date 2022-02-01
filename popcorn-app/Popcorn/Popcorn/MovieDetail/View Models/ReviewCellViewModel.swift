//
//  ReviewCellViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewCellViewModel {
    
    private let apiService: APIServiceProtocol
    private let disposeBag: DisposeBag
    private let review: BehaviorRelay<Review>
    private let avatarBehaviorRelay: BehaviorRelay<UIImage>

    var isExpanded = false
    let avatar: Driver<UIImage>
    let name: Driver<String>
    let date: Driver<String>
    let rating: Driver<Rating>
    let description: Driver<String>
    
    init(apiService: APIServiceProtocol, review: Review) {
        self.apiService = apiService
        self.disposeBag = DisposeBag()
        self.review = BehaviorRelay(value: review)
        self.avatarBehaviorRelay = BehaviorRelay(value: Asset.Images.popcorn.image)
        self.avatar = avatarBehaviorRelay.asDriver(onErrorJustReturn: Asset.Images.popcorn.image)
        self.name = self.review.map {
            let name = $0.authorDetails.name
            return !name.isEmpty ? name : $0.author
        }.asDriver(onErrorJustReturn: "")
        self.date = self.review.map { $0.prettyDate }.asDriver(onErrorJustReturn: "")
        self.rating = self.review.map { Rating(totalFilled: $0.rating) }.asDriver(onErrorJustReturn: Rating(totalFilled: 0))
        self.description = self.review.map { $0.content }.asDriver(onErrorJustReturn: "")
        
        downloadAvatar()
    }
    
    func downloadAvatar(){
        guard let avatarPath = review.value.authorDetails.formattedAvatarPath else {
            return
        }
        let request = RequestFactory.reviewAvatarRequest(avatarPath: avatarPath)
        apiService.downloadImage(request: request)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] image in
                self?.avatarBehaviorRelay.accept(image)
            }
            .disposed(by: disposeBag)
    }
    
}

