//
//  Builders.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
extension HomeViewController {
    static func make(with viewModel: HomeViewModelProtocol) -> HomeViewController {
        let homeViewController = HomeViewController()
        homeViewController.viewModel = viewModel
        return homeViewController
    }
}
