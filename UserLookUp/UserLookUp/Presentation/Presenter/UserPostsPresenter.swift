//
//  UserPostsPresenter.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//


import Foundation

public final class UserPostsPresenter: UserPostsPresenterContract {
    
    private weak var view: UserPostsViewContract?
    private var dataManager: UserPostsDataManagerContract
    private let userId: Int
    private var posts: [Post] = []
    
    public var numberOfPosts: Int {
        return posts.count
    }
    
    public init(view: UserPostsViewContract,
                dataManager: UserPostsDataManagerContract,
                userId: Int) {
        self.view = view
        self.dataManager = dataManager
        self.userId = userId
    }
    
    public func viewDidLoad() {
        fetchPosts()
    }
    
    public func didSelectPost(at index: Int) {
        
    }
    
    public func post(at index: Int) -> Post? {
        guard index < posts.count else { return nil }
        return posts[index]
    }
    
    private func fetchPosts() {
        view?.showLoading()
        dataManager.fetchPosts(userId: userId, successBlock: { [weak self] posts in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.posts = posts
                self.view?.hideLoading()
                self.view?.showPosts(posts)
            }
        }, failureBlock: { [weak self] error in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.view?.showError(self?.errorMessage(for: error) ?? "Failed to load posts")
            }
        })
    }
    
    private func errorMessage(for error: UserPostsError) -> String {
        switch error.type {
        case .networkUnavailable:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .decodingFailed:
            return "Failed to process posts"
        case .requestFailed:
            return error.message ?? "Failed to load posts"
        case .unknown:
            return error.message ?? "Something went wrong"
        }
    }
}
