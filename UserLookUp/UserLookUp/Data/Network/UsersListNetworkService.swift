import Foundation


public final class UsersListNetworkService: UsersListNetworkServiceContract {
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    public init() {}
    
    public func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            failureBlock(UsersListError(type: .requestFailed, message: LocalizationManager.Error.Network.invalidResponse))
            return
        }
        
        Task {
            do {
                let users: [User] = try await NetworkUtility.fetch(from: url)
                successBlock(users)
            } catch {
                let (errorType, message) = NetworkUtility.mapError(error)
                let usersErrorType: UsersListErrorType
                switch errorType {
                    case .requestFailed: usersErrorType = .requestFailed
                    case .networkUnavailable: usersErrorType = .networkUnavailable
                    case .timeout: usersErrorType = .timeout
                    case .decodingFailed: usersErrorType = .decodingFailed
                    case .unknown: usersErrorType = .unknown
                }
                failureBlock(UsersListError(type: usersErrorType, message: message))
            }
        }
    }
}

