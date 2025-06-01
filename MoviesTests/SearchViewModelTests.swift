import XCTest
@testable import Movies

@MainActor
class SearchViewModelTests: XCTestCase {

    func testLoadMoviesSuccess() async {
        
        let expectedMovies = [
            Movie(adult: false, backdropPath: "", genreIds: [], id: 3, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4),
            Movie(adult: false, backdropPath: "", genreIds: [], id: 9, originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", releaseDate: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4)
        ]
        
        let expectedResponse = MovieResponse(page: 1, results: expectedMovies, totalPages: 5, totalResults: 6)
       
        let httpClient = NetworkClientMock()
        
        httpClient.sendRequestHandler = { _ in
            return .success(expectedResponse)
        }
        
        let viewModel = SearchViewModel(moviesApi: httpClient)
        viewModel.category = .movie
        
        await viewModel.searchMovies(using: "test")
        
        XCTAssertEqual(viewModel.movies, expectedMovies)
    }
    
    func testLoadTVShowsSuccess() async {
        
        let expectedMovies = [
            TVShow(adult: false, backdropPath: "", genreIds: [], id: 3, originCountry: [], originalLanguage: "en", originalName: "movie", overview: "Description", popularity: 4.5, posterPath: "", firstAirDate: "", name: "Movie", voteAverage: 4.5, voteCount: 4),
            TVShow(adult: false, backdropPath: "", genreIds: [], id: 9, originCountry: [], originalLanguage: "movie",originalName:"kk", overview: "Description", popularity: 4.5, posterPath: "", firstAirDate: "", name: "Movie", voteAverage: 4.5, voteCount: 4)
        ]

        let expectedResponse = TVShowResponse(page: 1, results: expectedMovies, totalPages: 5, totalResults: 6)
       
        let httpClient = NetworkClientMock()
        
        httpClient.sendRequestHandler = { _ in
            return .success(expectedResponse)
        }
        
        let viewModel = SearchViewModel(moviesApi: httpClient)
        viewModel.category = .tvShow
        
        await viewModel.searchMovies(using: "test")
        
        XCTAssertEqual(viewModel.tvShows, expectedMovies)
    }
}

