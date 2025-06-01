import XCTest
@testable import Movies

@MainActor
class MovieDetailViewModelTests: XCTestCase {
    
    func testLoadMovieDetailSuccess() async {
        
        let expectedResponse = MovieDetailsResponse(adult: false, backdropPath: "", belongsToCollection: nil, budget: 34, genres: [], homepage: "home", id: 3, imdbId: nil, originCountry: [], originalLanguage: "en", originalTitle: "movie", overview: "Description", popularity: 4.5, posterPath: "", productionCompanies: [], productionCountries: [], releaseDate: "", revenue: 4, runtime: 5, spokenLanguages: [], status: "", tagline: "", title: "Movie", video: false, voteAverage: 4.5, voteCount: 4)
        
        let httpClient = NetworkClientMock()
        
        httpClient.sendRequestHandler = { _ in
            return .success(expectedResponse)
        }
        
        let viewModel = MovieDetailViewModel(movieId: 123, moviesApi: httpClient)
        
        await viewModel.loadMovieDetail()
        
        XCTAssertEqual(viewModel.movie, expectedResponse)
        XCTAssertEqual(viewModel.movie?.title, "Movie")
    }
    
    func testLoadMovieDetailFailure() async {
        
        let httpClient = NetworkClientMock()
        let expectedError = RequestError.decodingError(data: Data())
        
        httpClient.sendRequestHandler = { _ in
            return .failure(expectedError)
        }
        
        let viewModel = MovieDetailViewModel(movieId: 123, moviesApi: httpClient)
        
        await viewModel.loadMovieDetail()
        
        XCTAssertNil(viewModel.movie)
    }
}

