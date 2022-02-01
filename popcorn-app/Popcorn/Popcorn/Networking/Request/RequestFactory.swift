//
//  RequestBuilder.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 18.11.2021.
//

import Foundation

struct RequestFactory {
    
    static func popularMoviesRequest() -> PopularMoviesRequest {
        PopularMoviesRequest(httpMethod: .GET, path: "/movie/popular", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func noMoviesRequest() -> NowPlayMoviesRequest {
        NowPlayMoviesRequest(httpMethod: .GET, path: "/movie/now_playing", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func upcomingMoviesRequest() -> UpcomingMoviesRequest {
        UpcomingMoviesRequest(httpMethod: .GET, path: "/movie/upcoming", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func topMoviesRequest() -> TopMoviesRequest {
        TopMoviesRequest(httpMethod: .GET, path: "/movie/top_rated", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func movieDetailRequest(movieId: Int) -> MovieDetailRequest {
        MovieDetailRequest(movieId: movieId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func searchMovieRequest(searchKey: String) -> SearchMovieRequest {
        SearchMovieRequest(searchKey: searchKey, httpMethod: .GET, path: "/search/movie", headers: defaultHeaders())
    }
    
    static func genresRequest() -> GenreRequest {
        GenreRequest(httpMethod: .GET, path: "/genre/movie/list", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func moviePosterRequest(path: String?, size: String?) -> ImageDownloadRequest {
        ImageDownloadRequest(path: path, size: size)
    }
    
    static func genrePosterRequest(baseUrl: String) -> ImageDownloadRequest {
        ImageDownloadRequest(baseUrl: baseUrl, path: nil, size: nil)
    }
    
    static func artistsRequest() -> ArtistsRequest {
        ArtistsRequest(httpMethod: .GET, path: "/person/popular", headers: defaultHeaders(), params: defaultParams())
    }
    
    static func artistPoster(path: String?, size: String?) -> ImageDownloadRequest {
        ImageDownloadRequest(path: path, size: size)
    }
    
    static func castRequest(movieId: Int) -> CastRequest {
        CastRequest(movieId: movieId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func reviewsRequest(movieId: Int) -> ReviewsRequest {
        ReviewsRequest(movieId: movieId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func reviewAvatarRequest(avatarPath: String) -> ImageDownloadRequest {
        ImageDownloadRequest(baseUrl: avatarPath, path: nil, size: nil)
    }
    
    static func similarMoviesRequest(movieId: Int) -> SimilarMoviesRequest {
        SimilarMoviesRequest(movieId: movieId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func artistDetailRequest(artistId: Int) -> ArtistDetailRequest {
        ArtistDetailRequest(artistId: artistId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func movieCreditsRequest(artistId: Int) -> MovieCreditsRequest {
        MovieCreditsRequest(artistId: artistId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
    static func profileRequest(artistId: Int) -> ProfilesRequest {
        ProfilesRequest(artistId: artistId, httpMethod: .GET, headers: defaultHeaders(), params: defaultParams())
    }
    
}

extension RequestFactory {
    private static func defaultHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    private static func defaultParams() -> [String: String] {
        return ["api_key": APIUtils.apiKey]
    }
}
