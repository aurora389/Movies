import SwiftUI

struct MovieItem: View {
    var imageURL: URL?
    var title: String
    var movieId: Int
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MovieImage(imageURL: imageURL)
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(title)
                .font(.caption.weight(.bold))
                .lineLimit(1)
                .foregroundColor(.primary)
            Text(description)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
