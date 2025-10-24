//
//  UserPostsDataManager.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import Foundation


public final class UserPostsDataManager: UserPostsDataManagerContract {
    
    private var networkService: UserPostsNetworkServiceContract
    
    public init(networkService: UserPostsNetworkServiceContract) {
        self.networkService = networkService
    }
    
    public func fetchPosts(userId: Int, successBlock: @escaping ([Post]) -> Void, failureBlock: @escaping (UserPostsError) -> Void) {
        networkService.fetchPosts(userId: userId, successBlock: { posts in
            // Here you can add additional data processing, caching, etc.
            successBlock(posts)
        }, failureBlock: { error in
            failureBlock(error)
        })
    }
}
