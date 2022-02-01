////
////  APIRequest.swift
////  Popcorn
////
////  Created by Daniel Gogozan on 17.11.2021.
////
//
//import Foundation
//
//enum APIRequest: Int {
//    case popularMovies, nowMovies, topMovies, upcomingMovies
//    case movieDetail
//}
//
//extension APIRequest: Request {
//
//    var httpMethod: HttpMethod {
//        switch self {
//        case .popularMovies, .nowMovies, .topMovies, .upcomingMovies, .movieDetail:
//               return HttpMethod.GET
//        }
//    }
//
//    var headers: [String : String] {
//        return ["Content-Type": "application/json"]
//    }
//
//    var baseUrl: String {
//        APIUtils.baseUrl
//    }
//
//    var relativeUrl: String {
//        switch self {
//        case .popularMovies:
//            return "movie/popular"
//        case .nowMovies:
//            return "movie/now_playing"
//        case .topMovies:
//            return "movie/top_rated"
//        case .upcomingMovies:
//            return "movie/upcoming"
//        case .movieDetail:
//            return "movie"
//        }
//    }
//
//    var params: [String : String] {
//        let queryParams = ["api_key": APIUtils.apiKey]
//        // a switch must be implemented if the request impose further query params
//        return queryParams
//    }
//}
//
//extension APIRequest {
//
//    func toUrlRequest(extraUrlComponents: [String] = []) -> URLRequest {
//        guard let baseUrl = URL(string: baseUrl),
//            var components = URLComponents(url: baseUrl.appendingPathComponent(buildRelativeUrl(components: extraUrlComponents)), resolvingAgainstBaseURL: false) else {
//            fatalError("Unable to create URL or append path component \(relativeUrl)")
//        }
//
//        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
//        guard let url = components.url else {
//            fatalError("Unable to obtain url from components")
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod.rawValue
//        headers.forEach { request.addValue($0, forHTTPHeaderField: $1) }
//        return request
//    }
//
//    private func buildRelativeUrl(components: [String]) -> String {
//        var finalRelativeUrl = relativeUrl
//        components.forEach { finalRelativeUrl.append("/" + $0) }
//        return finalRelativeUrl
//    }
//
//}
