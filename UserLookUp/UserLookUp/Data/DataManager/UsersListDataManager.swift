//
//  UsersListDataManager.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//


import Foundation

// MARK: - Users List Data Manager

public final class UsersListDataManager: UsersListDataManagerContract {
    
    private var networkService: UsersListNetworkServiceContract
    
    public init(networkService: UsersListNetworkServiceContract) {
        self.networkService = networkService
    }
    
    public func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void) {
        networkService.fetchUsers(successBlock: { users in
            // Here you can add additional data processing, caching, etc.
            successBlock(users)
        }, failureBlock: { error in
            failureBlock(error)
        })
    }
}
