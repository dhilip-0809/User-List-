import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case networkUnavailable
    case timeout
    case decodingFailed
    case requestFailed(Int)
    case unknown
}

final class NetworkUtility {
    static func fetch<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.requestFailed(httpResponse.statusCode)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        } catch URLError.notConnectedToInternet {
            throw NetworkError.networkUnavailable
        } catch URLError.timedOut {
            throw NetworkError.timeout
        } catch is DecodingError {
            throw NetworkError.decodingFailed
        } catch {
            throw NetworkError.unknown
        }
    }
    
    static func mapError(_ error: Error) -> (errorType: ErrorType, message: String) {
        switch error as? NetworkError {
        case .networkUnavailable:
            return (.networkUnavailable, LocalizationManager.Error.Network.noConnection)
        case .timeout:
            return (.timeout, LocalizationManager.Error.Network.timeout)
        case .invalidResponse, .invalidURL:
            return (.requestFailed, LocalizationManager.Error.Network.invalidResponse)
        case .decodingFailed:
            return (.decodingFailed, LocalizationManager.Error.Users.processingFailed)
        case .requestFailed:
            return (.requestFailed, LocalizationManager.Error.Network.general)
        case .unknown, .none:
            return (.unknown, LocalizationManager.Error.general)
        }
    }
}

// Common error types for both Users and Posts
enum ErrorType {
    case networkUnavailable
    case timeout
    case requestFailed
    case decodingFailed
    case unknown
}
