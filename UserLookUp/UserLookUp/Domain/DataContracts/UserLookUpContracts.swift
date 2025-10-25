//
//  UserLookUpContracts.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import Foundation

// MARK: - Users List Protocols

public protocol UsersListViewContract: AnyObject {
    func showUsers(_ users: [User])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

public protocol UsersListPresenterContract: AnyObject {
    func viewDidLoad()
    func didSelectUser(at index: Int)
    func didPullToRefresh()
    func didSearchUsers(with query: String)
    var numberOfUsers: Int { get }
    func user(at index: Int) -> User?
}

public protocol UsersListDataManagerContract {
    func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void)
}

public protocol UsersListNetworkServiceContract {
    func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void)
}

public protocol UsersListRouterContract: AnyObject {
    func navigateToUserDetail(user: User)
}

// MARK: - User Posts Protocols

public protocol UserPostsViewContract: AnyObject {
    func showPosts(_ posts: [Post])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

public protocol UserPostsPresenterContract: AnyObject {
    func viewDidLoad()
    func didSelectPost(at index: Int)
    var numberOfPosts: Int { get }
    func post(at index: Int) -> Post?
}

public protocol UserPostsDataManagerContract {
    func fetchPosts(userId: Int, successBlock: @escaping ([Post]) -> Void, failureBlock: @escaping (UserPostsError) -> Void)
}

public protocol UserPostsNetworkServiceContract {
    func fetchPosts(userId: Int, successBlock: @escaping ([Post]) -> Void, failureBlock: @escaping (UserPostsError) -> Void)
}


public enum UsersListErrorType {
    case networkUnavailable
    case timeout
    case decodingFailed
    case requestFailed
    case unknown
}

public final class UsersListError: Error {
    let type: UsersListErrorType
    let message: String?
    
    init(type: UsersListErrorType, message: String? = nil) {
        self.type = type
        self.message = message
    }
}

public enum UserPostsErrorType {
    case networkUnavailable
    case timeout
    case decodingFailed
    case requestFailed
    case unknown
}

public final class UserPostsError: Error {
    let type: UserPostsErrorType
    let message: String?
    
    init(type: UserPostsErrorType, message: String? = nil) {
        self.type = type
        self.message = message
    }
}
