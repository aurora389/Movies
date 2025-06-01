import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {

    @Published var movie: MovieDetailsResponse?
    
    private let moviesApi: MoviesAPI
    private let movieId: Int

    init(movieId: Int, moviesApi: MoviesAPI = NetworkClient()) {
        self.movieId = movieId
        self.moviesApi = moviesApi
    }

    func loadMovieDetail() async {
        do {
            let result = try await moviesApi.movieDetails(id: movieId)
            movie = result
        } catch {
            print(error.localizedDescription)
        }
    }
}

