import Foundation

struct MovieDetailsResponse: Equatable {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbId: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

extension MovieDetailsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetailsResponse {
    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)")
    }
    
    var runtimeInHoursAndMinutes: String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)min"
    }
}

struct Genre: Decodable, Equatable {
    let id: Int
    let name: String
}

struct ProductionCompany: Decodable, Equatable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Decodable, Equatable {
    let iso3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Decodable, Equatable {
    let englishName: String
    let iso639_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
        case englishName = "english_name"
    }
}

struct BelongsToCollection: Decodable, Equatable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
