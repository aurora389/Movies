import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    
    private let moviesApi: MoviesAPI
    private var page = 1
    private var isInitiallyLoaded = false
    private var totalMoviesAvailable: Int?
    private var loadedMoviesCount: Int?
    private var isLoading = false
    private var dataIsLoading = false
    
    init(moviesApi: MoviesAPI = NetworkClient()) {
        self.moviesApi = moviesApi
    }
    
    func loadInitialMovies() {
        guard !isInitiallyLoaded else { return }
        page = 1
        Task {
            await requestMovies(for: page)
        }
        isInitiallyLoaded = true
    }
    
    func loadMoviesIfNeeded(index: Int) {
        guard let loadedMoviesCount, let totalMoviesAvailable else { return }
        guard index >= loadedMoviesCount - 1 else { return }
        
        if moreMoviesRemaining(loadedMoviesCount, totalMoviesAvailable) && !dataIsLoading {
            page += 1
            Task {
                await requestMovies(for: page)
            }
        }
    }
}

private extension MoviesViewModel {
    
    func requestMovies(for page: Int) async {
        dataIsLoading = true
        do {
            let response = try await moviesApi.fetchMovies(for: page)
            totalMoviesAvailable = response.totalResults
            movies.append(contentsOf: response.results)
            loadedMoviesCount = movies.count
            dataIsLoading = false
        } catch {
            
        }
    }
    
    func moreMoviesRemaining(_ itemsLoadedCount: Int, _ totalItemsAvailable: Int) -> Bool {
        itemsLoadedCount < totalItemsAvailable
    }
}
