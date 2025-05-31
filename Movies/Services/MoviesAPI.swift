import Foundation

protocol MoviesAPI {
    func fetchMovies(for page: Int) async throws -> MovieResponse
    func searchMovies(for query: String) async throws -> MovieResponse
    func searchSeries(for query: String) async throws -> TVShowResponse
}
