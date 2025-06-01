import SwiftUI
import AsyncAlgorithms

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search movies...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Picker("Categories", selection: $viewModel.category) {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if viewModel.screenState == .initial {
                EmptySearchView()
            }
            
            if viewModel.screenState == .searching {
                ProgressView()
                    .padding()
            }
            
            if viewModel.screenState == .resultsFound && viewModel.category == .movie {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.movies) { movie in
                                MovieItem(imageURL: movie.thumbnailURL, title: movie.originalTitle, movieId: movie.id, description: movie.overview)
                        }
                    }
                    .padding()
                }
            }
            if viewModel.screenState == .resultsFound && viewModel.category == .tvShow {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.tvShows) { tvShow in
                                MovieItem(imageURL: tvShow.posterURL, title: tvShow.originalName, movieId: tvShow.id, description: tvShow.overview)
                        }
                    }
                    .padding()
                }
            }
            if viewModel.screenState == .error {
                ErrorView {
                    await viewModel.searchMovies(using: viewModel.searchText)
                }
            }
            if viewModel.screenState == .resultNotFound {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle("Search")
    }
}

struct EmptySearchView: View {
    
    var body: some View {
        VStack {
            Text("Search for movies or TV shows")
                .font(.headline)
            Text("Start typing to search...")
                .font(.caption)
        }
        .padding()
    }
}

struct ErrorView: View {
    
    let action: () async -> Void
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Something went wrong")
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding(.horizontal)
            Button("Retry") {
                Task {
                    await action()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
