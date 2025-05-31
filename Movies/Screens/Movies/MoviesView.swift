import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 16
                ) {
                    ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                        MovieItem(imageURL: movie.thumbnailURL, title: movie.originalTitle, movieId: movie.id, description: movie.overview)
                            .onAppear {
                                viewModel.loadMoviesIfNeeded(index: index)
                            }
                    }
                }
                .padding()
            }
            .task {
                viewModel.loadInitialMovies()
            }
        }
    }
}
