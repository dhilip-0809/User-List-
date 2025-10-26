//
//  UserPostsNetworkService.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import Foundation



public final class UserPostsNetworkService: UserPostsNetworkServiceContract {
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    public init() {}
    
    public func fetchPosts(userId: Int, successBlock: @escaping ([Post]) -> Void, failureBlock: @escaping (UserPostsError) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts?userId=\(userId)") else {
            failureBlock(UserPostsError(type: .requestFailed, message: LocalizationManager.Error.Network.invalidResponse))
            return
        }
        
        Task {
            do {
                let posts: [Post] = try await NetworkUtility.fetch(from: url)
                successBlock(posts)
            } catch {
                let (errorType, message) = NetworkUtility.mapError(error)
                let postsErrorType: UserPostsErrorType
                switch errorType {
                    case .requestFailed: postsErrorType = .requestFailed
                    case .networkUnavailable: postsErrorType = .networkUnavailable
                    case .timeout: postsErrorType = .timeout
                    case .decodingFailed: postsErrorType = .decodingFailed
                    case .unknown: postsErrorType = .unknown
                }
                failureBlock(UserPostsError(type: postsErrorType, message: message))
            }
        }
    }
}
