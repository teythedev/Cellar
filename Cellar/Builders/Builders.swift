//
//  Builders.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit
extension HomeViewController {
    static func make() -> UIViewController {
        let homeViewController = HomeViewController()
        let authListener = FireBaseAuthListerner()
        let databaseService = FirebaseDataBaseService()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        homeViewController.viewModel = HomeViewModel()
        homeViewController.viewModel?.databaseService = databaseService
        homeViewController.viewModel?.authListener = authListener
        return navigationController
    }
}


extension LoginViewController {
    static func make() -> UIViewController {
        let lgn = LoginViewController()
        let authService = FirebaseAuthService()
        lgn.viewModel = LoginViewModel()
        lgn.viewModel?.authService = authService
        let navController = UINavigationController(rootViewController: lgn)

        return navController
    }
}

extension RegisterViewController {
    static func make() -> UIViewController {
        let register = RegisterViewController()
        let authService = FirebaseAuthService()
        let firebaseDatabaseService = FirebaseDataBaseService()
        register.viewModel = RegisterViewModel()
        register.viewModel?.databaseService = firebaseDatabaseService
        register.viewModel?.authService = authService
        return register
    }
}
