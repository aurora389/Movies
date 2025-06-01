import XCTest
@testable import Movies

class NetworkClientMock: MoviesAPI {
    
    public var sendRequestHandler: ((MoviesEndpoint) -> Result<Any, Error>)?
    
    func fetchMovies(for page: Int) async throws -> MovieResponse {
        switch sendRequestHandler?(.topRatedMovies(page: page)) {
        case .success(let response):
            if let response = response as? MovieResponse {
                return response
            }
        case let .failure(error):
            throw error
        default: break
        }
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
    func searchMovies(for query: String) async throws -> MovieResponse {
        switch sendRequestHandler?(.searchMovies(query: query)) {
        case let .success( response):
            if let response = response as? MovieResponse {
                return response
            }
        case let .failure(error):
            throw error
        default: break
        }
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
    func searchSeries(for query: String) async throws -> TVShowResponse {
        switch sendRequestHandler?(.searchSeries(query: query)) {
        case let .success( response):
            if let response = response as? TVShowResponse {
                return response
            }
        case let .failure(error):
            throw error
        default: break
        }
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
    func movieDetails(id: Int) async throws -> MovieDetailsResponse {
        switch sendRequestHandler?(.movieDetails(id: id)) {
        case let .success( response):
            if let response = response as? MovieDetailsResponse {
                return response
            }
        case let .failure(error):
            throw error
        default: break
        }
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
}
