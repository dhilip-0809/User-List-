//
//  UsersListRouter.swift
//  UserLookUp
//
//  Created by Dhilip R on 23/10/25.
//

import UIKit


public final class UsersListRouter: UsersListRouterContract {
    
    private weak var viewController: UIViewController?
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func navigateToUserDetail(user: User) {
        let detailVC = UserDetailAssembler.createModule(user: user)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
