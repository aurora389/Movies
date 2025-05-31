import Foundation

enum RequestError: Error {
    case invalidURL
    case serverError(statusCode: Int, data: Data)
    case decodingError(data: Data)
    case invalidResponse
}
