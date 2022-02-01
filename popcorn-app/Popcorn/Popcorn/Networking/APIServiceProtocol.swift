//
//  APIServiceProtocol.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 22.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol APIServiceProtocol {
    
    func sendRequest<T: Codable>(request: Request) -> Observable<T>
    
    func downloadImage(request: ImageDownloadRequest) -> Observable<UIImage>
    
}
