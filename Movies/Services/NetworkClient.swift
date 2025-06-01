import Foundation

class NetworkClient: MoviesAPI {

    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchMovies(for page: Int) async throws -> MovieResponse {
        return try await fetch(from: .topRatedMovies(page: page), responseType: MovieResponse.self)
    }
    
    func searchMovies(for query: String) async throws -> MovieResponse {
        return try await fetch(from: .searchMovies(query: query), responseType: MovieResponse.self)
    }
    
    func searchSeries(for query: String) async throws -> TVShowResponse {
        return try await fetch(from: .searchSeries(query: query), responseType: TVShowResponse.self)
    }
    
    func movieDetails(id: Int) async throws -> MovieDetailsResponse {
        return try await fetch(from: .movieDetails(id: id), responseType: MovieDetailsResponse.self)
    }
}

private extension NetworkClient {
    
    func fetch<T: Decodable>(from endpoint: MoviesEndpoint, responseType: T.Type) async throws -> T {
        guard let url = buildURL(endpoint: endpoint) else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }
            guard 200..<300 ~= response.statusCode else {
                throw RequestError.serverError(statusCode: response.statusCode, data: data)
            }
            guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                throw RequestError.decodingError(data: data)
            }
            return decodedResponse
        }
    }

    func buildURL(endpoint: MoviesEndpoint) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return components.url
    }
}
