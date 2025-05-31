import Foundation

enum MoviesEndpoint: Equatable {
    case topRatedMovies(page: Int)
    case searchMovies(query: String)
    case searchSeries(query: String)
    case movieDetails(id: Int)
}

extension MoviesEndpoint: Endpoint {
    var scheme: String { "https" }
    
    var host: String { NetworkConfig.host }
    
    var path: String {
        switch self {
            case .topRatedMovies:  "/3/movie/popular"
            case .searchMovies: "/3/search/movie"
            case .searchSeries: "/3/search/tv"
            case let .movieDetails(movieId): "/3/movie/\(movieId)"
        }
    }

    var method: HTTPMethod { .get }
    
    var header: [String : String] {
        return [
            "Authorization": "Bearer \(NetworkConfig.accessToken)",
            "accept": "application/json"]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .topRatedMovies(page: page):
            return [URLQueryItem(name: "page", value: String(page))]
        case let .searchMovies(query: query), let .searchSeries(query: query):
            return [URLQueryItem(name: "query", value: query)]
        case .movieDetails:
            return nil
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
}
