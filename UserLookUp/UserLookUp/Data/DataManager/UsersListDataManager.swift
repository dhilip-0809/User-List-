//
//  UsersListDataManager.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//


import Foundation


public final class UsersListDataManager: UsersListDataManagerContract {
    
    private var networkService: UsersListNetworkServiceContract
    
    public init(networkService: UsersListNetworkServiceContract) {
        self.networkService = networkService
    }
    
    public func fetchUsers(successBlock: @escaping ([User]) -> Void, failureBlock: @escaping (UsersListError) -> Void) {
        networkService.fetchUsers(successBlock: { users in
            successBlock(users)
        }, failureBlock: { error in
            failureBlock(error)
        })
    }
}
