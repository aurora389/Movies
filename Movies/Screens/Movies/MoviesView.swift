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
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MovieItem(imageURL: movie.thumbnailURL, title: movie.originalTitle, movieId: movie.id, description: movie.overview)
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoviesIfNeeded(index: index)
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            .task {
                await viewModel.loadInitialMovies()
            }
        }
    }
}
