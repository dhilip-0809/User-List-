//
//  UsersListPresenter.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//


//
//  UserListPresenter.swift
//  User LookUp
//
//  Created by Dhilip R on 23/10/25.
//

import Foundation

// MARK: - Users List Presenter

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
        if query.isEmpty {
            filteredUsers = allUsers
        } else {
            filteredUsers = allUsers.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.username.localizedCaseInsensitiveContains(query) ||
                $0.company.name.localizedCaseInsensitiveContains(query)
            }
        }
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
                self.filteredUsers = self.allUsers
                self.view?.hideLoading()
                self.view?.showUsers(self.filteredUsers)
            }
            
        }, failureBlock: { [weak self] error in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.view?.showError(self?.errorMessage(for: error) ?? "An error occurred")
            }
        })
    }
    
    private func errorMessage(for error: UsersListError) -> String {
        switch error.type {
        case .networkUnavailable:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .decodingFailed:
            return "Failed to process data"
        case .requestFailed:
            return error.message ?? "Request failed"
        case .unknown:
            return error.message ?? "Something went wrong"
        }
    }
}
