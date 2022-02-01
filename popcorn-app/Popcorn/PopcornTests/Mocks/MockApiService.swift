//
//  MockApiService.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 22.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
@testable import Popcorn

class MockApiService: APIServiceProtocol {
    
    var responses: [String: Any] = [:]
    
    func sendRequest<T>(request: Request) -> Observable<T> where T : Decodable, T : Encodable {
        responses[request.path] as? Observable<T> ?? Observable.error(ApiError.fail)
    }
    
    func downloadImage(request: ImageDownloadRequest) -> Observable<UIImage> {
        let path = request.baseUrl + (request.path ?? "")
        return responses[path] as? Observable<UIImage> ??  Observable.error(ApiError.fail)
    }
    
}

enum ApiError: Error {
    case fail
}

