import Foundation
import Combine

enum ScreenState {
    case initial
    case searching
    case resultNotFound
    case resultsFound
    case error
}

enum Category: String, CaseIterable, Identifiable {
    case tvShow
    case movie
    var id: String { rawValue }
}

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query = ""
    @Published var movies: [Movie] = []
    @Published var tvShows: [TVShow] = []
    @Published var searchText = ""
    @Published var debouncedQuery = ""
    @Published var screenState: ScreenState = .initial
    @Published var category: Category = .tvShow
    
    private let moviesApi: MoviesAPI
    private var task: Task<Void, Never>? = nil
    
    init(moviesApi: MoviesAPI = NetworkClient()) {
        self.moviesApi = moviesApi
        
        task = Task {
            for await query in AsyncPublisher(
                $searchText
                    .receive(on: RunLoop.main)
            )
                .debounce(for: .seconds(0.5)) {
                await searchMovies(using: query)
            }
        }
    }
    
    func searchMovies(using query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            movies = []
            tvShows = []
            screenState = .initial
            return
        }
        screenState = .searching
        
        do {
            switch category {
            case .tvShow:
                let result = try await moviesApi.searchSeries(for: query)
                self.tvShows = result.results
            case .movie:
                let result = try await moviesApi.searchMovies(for: query)
                self.movies = result.results
            }
            screenState = tvShows.isEmpty && movies.isEmpty ?  .resultNotFound : .resultsFound
            
        } catch {
            print(error.localizedDescription)
            screenState = .error
        }
    }

    deinit {
        task?.cancel()
    }
}
