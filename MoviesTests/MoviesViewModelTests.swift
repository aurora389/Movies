import XCTest
import XCTest
import Combine

@testable import Movies

@MainActor
class MoviesViewModelTests: XCTestCase {
    
    func testLoadInitialMovies() async  {
        
        let expectedMovies = [
            Movie(adult: false, backdropPath: "", genreIds: [], id: 3, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4),
            Movie(adult: false, backdropPath: "", genreIds: [], id: 9, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4)
        ]
        
        let expectedResponse = MovieResponse(page: 1, results: expectedMovies, totalPages: 5, totalResults: 6)
        
        let httpClient = NetworkClientMock()
        
        let viewModel = MoviesViewModel(moviesApi: httpClient)
        
        httpClient.sendRequestHandler = { endpoint in
            XCTAssertEqual(endpoint, .topRatedMovies(page: 1))
            return .success(expectedResponse)
        }
        
        await viewModel.loadInitialMovies()
        
        XCTAssertEqual(viewModel.movies, expectedMovies)
    }
    
    func testLoadMoviesIfNeeded() async {
        let firstMovies = [
            Movie(adult: false, backdropPath: "", genreIds: [], id: 3, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4),
            Movie(adult: false, backdropPath: "", genreIds: [], id: 9, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4)
        ]
        
        let secondMovies = [
            Movie(adult: false, backdropPath: "", genreIds: [], id: 7, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4),
            Movie(adult: false, backdropPath: "", genreIds: [], id: 8, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4)
        ]
        
        let firstExpectedResponse = MovieResponse(page: 1, results: firstMovies, totalPages: 5, totalResults: 6)
        let secondExpectedResponse = MovieResponse(page: 2, results: secondMovies, totalPages: 5, totalResults: 6)
        
        let httpClient = NetworkClientMock()
        
        let viewModel = MoviesViewModel(moviesApi: httpClient)
        
        httpClient.sendRequestHandler = { endpoint in
            XCTAssertEqual(endpoint, .topRatedMovies(page: 1))
            return .success(firstExpectedResponse)
        }
        
        await viewModel.loadInitialMovies()
        
        XCTAssertEqual(viewModel.movies, firstMovies)
        
        httpClient.sendRequestHandler = { endpoint in
            XCTAssertEqual(endpoint, .topRatedMovies(page: 2))
            return .success(secondExpectedResponse)
        }
        
        await viewModel.loadMoviesIfNeeded(index: 2)
        
        XCTAssertEqual(viewModel.movies, firstMovies + secondMovies)
    }
}
