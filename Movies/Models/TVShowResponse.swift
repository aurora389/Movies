struct TVShowResponse {
    let page: Int
    let results: [TVShow]
    let totalPages: Int
    let totalResults: Int
}

extension TVShowResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
