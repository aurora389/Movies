import SwiftUI

struct MovieDetailView: View {
    
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            if let movie = viewModel.movie {
                VStack(alignment: .leading, spacing: 24) {
                    AsyncImage(url: movie.posterURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                    
                    MovieInfoView(title: movie.title,
                                  voteCount: movie.voteCount,
                                  runtime: movie.runtimeInHoursAndMinutes)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    MovieOverviewView(overview: movie.overview,
                                      releaseDate: movie.releaseDate,
                                      status: movie.status)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.5)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Movie Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetail()
        }
    }
}

struct MovieInfoView: View {
    
    let title: String
    let voteCount: Int
    let runtime: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Label("\(voteCount)", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.headline)
                
                Text(runtime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct MovieOverviewView: View {
    
    let overview: String
    let releaseDate: String
    let status: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.title3.bold())
            Text(overview)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Facts")
                .font(.title3.bold())
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Release Date:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(releaseDate)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Status:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(status)
                        .foregroundColor(.secondary)
                }
            }
            .font(.subheadline)
        }
    }
}
