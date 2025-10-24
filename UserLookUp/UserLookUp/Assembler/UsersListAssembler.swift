//
//  UsersListAssembler.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import UIKit


public final class UsersListAssembler {
    
    public static func createModule() -> UIViewController {
        // Create View
        let viewController = UsersListViewController()
        
        // Create Network Service
        let networkService = UsersListNetworkService()
        
        // Create Data Manager
        let dataManager = UsersListDataManager(networkService: networkService)
        
        // Create Router
        let router = UsersListRouter(viewController: viewController)
        
        // Create Presenter
        let presenter = UsersListPresenter(
            view: viewController,
            dataManager: dataManager,
            router: router
        )
        
        // Inject Presenter to View
        viewController.presenter = presenter
        
        return viewController
    }
}

// MARK: - User Detail Assembler

public final class UserDetailAssembler {
    
    public static func createModule(user: User) -> UIViewController {
        // Create View
        let viewController = UserDetailViewController(user: user)
        
        // Create Network Service for Posts
        let networkService = UserPostsNetworkService()
        
        // Create Data Manager for Posts
        let dataManager = UserPostsDataManager(networkService: networkService)
        
        // Create Presenter for Posts
        let postsPresenter = UserPostsPresenter(
            view: viewController,
            dataManager: dataManager,
            userId: user.id
        )
        
        // Inject Presenter to View
        viewController.postsPresenter = postsPresenter
        
        return viewController
    }
}


public final class AppAssembler {
    
    public static func createUsersListModule() -> UINavigationController {
        let usersListVC = UsersListAssembler.createModule()
        let navigationController = UINavigationController(rootViewController: usersListVC)
        return navigationController
    }
}
