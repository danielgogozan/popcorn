//
//  APIService.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class APIService: APIServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func sendRequest<T: Codable>(request: Request) -> Observable<T> {
        return urlSession.rx.data(request: request.toUrlRequest())
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func downloadImage(request: ImageDownloadRequest) -> Observable<UIImage> {
        return Observable.create { observer in
            DispatchQueue.global(qos: .utility).async {
                if let url = request.url,
                   let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data) {
                    observer.onNext(img)
                } else {
                    observer.onNext(Asset.Images.popcorn.image)
                }
            }
            return Disposables.create()
        }
    }
    
}
