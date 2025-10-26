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
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    failureBlock(UserPostsError(type: .requestFailed, message: LocalizationManager.Error.Network.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    failureBlock(UserPostsError(type: .requestFailed, message: LocalizationManager.Error.Network.general))
                    return
                }
                
                let posts = try JSONDecoder().decode([Post].self, from: data)
                successBlock(posts)
                
            } catch URLError.notConnectedToInternet {
                failureBlock(UserPostsError(type: .networkUnavailable, message: LocalizationManager.Error.Network.noConnection))
            } catch URLError.timedOut {
                failureBlock(UserPostsError(type: .timeout, message: LocalizationManager.Error.Network.timeout))
            } catch is DecodingError {
                failureBlock(UserPostsError(type: .decodingFailed, message: LocalizationManager.Error.Posts.processingFailed))
            } catch {
                failureBlock(UserPostsError(type: .unknown, message: LocalizationManager.Error.general))
            }
        }
    }
}
