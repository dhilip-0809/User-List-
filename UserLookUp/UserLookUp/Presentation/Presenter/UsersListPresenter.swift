import Foundation

public final class UsersListPresenter: UsersListPresenterContract {
    
    private weak var view: UsersListViewContract?
    private var dataManager: UsersListDataManagerContract
    private var router: UsersListRouterContract?
    private var allUsers: [User] = []
    private var filteredUsers: [User] = []
    
    public var numberOfUsers: Int {
        return filteredUsers.count
    }
    
    public init(view: UsersListViewContract,
                dataManager: UsersListDataManagerContract,
                router: UsersListRouterContract?) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
    }
    
    public func viewDidLoad() {
        fetchUsers()
    }
    
    public func didPullToRefresh() {
        fetchUsers()
    }
    
    public func didSearchUsers(with query: String) {
        guard !query.isEmpty else {
            filteredUsers = []
            view?.showUsers(filteredUsers)
            return
        }
        
        let queryLower = query.lowercased()
        var prefixMatches: [User] = []
        var containsMatches: [User] = []
        
        for user in allUsers {
            let name = user.name.lowercased()
            let username = user.username.lowercased()
            
            if name.hasPrefix(queryLower) || username.hasPrefix(queryLower) {
                prefixMatches.append(user)
            } else if name.contains(queryLower) || username.contains(queryLower) {
                containsMatches.append(user)
            }
        }
        
        filteredUsers = prefixMatches + containsMatches
        view?.showUsers(filteredUsers)
    }
    
    public func didSelectUser(at index: Int) {
        guard index < filteredUsers.count else { return }
        let user = filteredUsers[index]
        router?.navigateToUserDetail(user: user)
    }
    
    public func user(at index: Int) -> User? {
        guard index < filteredUsers.count else { return nil }
        return filteredUsers[index]
    }
    
    private func fetchUsers() {
        view?.showLoading()
        dataManager.fetchUsers(successBlock: { [weak self] users in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.allUsers = users.sorted { $0.name < $1.name }
                self.filteredUsers = []
                self.view?.hideLoading()
                self.view?.showUsers(self.filteredUsers)
            }
        }, failureBlock: { [weak self] error in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.view?.showError(self?.errorMessage(for: error) ?? LocalizationManager.Error.general)
            }
        })
    }
    
    private func errorMessage(for error: UsersListError) -> String {
        switch error.type {
        case .networkUnavailable:
            return LocalizationManager.Error.Network.noConnection
        case .timeout:
            return LocalizationManager.Error.Network.timeout
        case .decodingFailed:
            return LocalizationManager.Error.Users.processingFailed
        case .requestFailed:
            return error.message ?? LocalizationManager.Error.Users.loadFailed
        case .unknown:
            return error.message ?? LocalizationManager.Error.general
        }
    }
}
