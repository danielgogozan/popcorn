//
//  ProfileViewModel.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 13.12.2021.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    private let apiService: APIServiceProtocol
    
    private let disposeBag: DisposeBag
    
    private let profileBehaviorRelay: BehaviorRelay<Profile>
    private let photoBehaviorRelay: BehaviorRelay<UIImage>
    let photo: Driver<UIImage>
    
    init(apiService: APIServiceProtocol, profile: Profile, size: APIUtils.ProfileSize) {
        self.apiService = apiService
        self.disposeBag = DisposeBag()
        self.profileBehaviorRelay = BehaviorRelay(value: profile)
        self.photoBehaviorRelay = BehaviorRelay(value: Asset.Images.popcorn.image)
        self.photo = photoBehaviorRelay.asDriver(onErrorJustReturn: Asset.Images.popcorn.image)
        
        self.downloadProfile(size: size)
    }
    
    func downloadProfile(size: APIUtils.ProfileSize) {
        let request = RequestFactory.artistPoster(path: profileBehaviorRelay.value.filePath, size: size.rawValue)
        apiService.downloadImage(request: request)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self] image in
                self?.photoBehaviorRelay.accept(image)
            }
            .disposed(by: self.disposeBag)
    }
    
}
