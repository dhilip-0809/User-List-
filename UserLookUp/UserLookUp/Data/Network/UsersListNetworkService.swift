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
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    failureBlock(UsersListError(type: .requestFailed, message: LocalizationManager.Error.Network.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    failureBlock(UsersListError(type: .requestFailed, message: LocalizationManager.Error.Network.general))
                    return
                }
                
                let users = try JSONDecoder().decode([User].self, from: data)
                successBlock(users)
                
            } catch URLError.notConnectedToInternet {
                failureBlock(UsersListError(type: .networkUnavailable, message: LocalizationManager.Error.Network.noConnection))
            } catch URLError.timedOut {
                failureBlock(UsersListError(type: .timeout, message: LocalizationManager.Error.Network.timeout))
            } catch is DecodingError {
                failureBlock(UsersListError(type: .decodingFailed, message: LocalizationManager.Error.Users.processingFailed))
            } catch {
                failureBlock(UsersListError(type: .unknown, message: LocalizationManager.Error.general))
            }
        }
    }
}

