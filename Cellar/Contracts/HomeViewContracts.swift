//
//  HomeViewContracts.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
protocol HomeViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput {
    case gotoLoginPage(ViewController)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func fetchCurrentUser(completion: @escaping (User?) -> ())
}
