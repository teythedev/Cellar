//
//  HomeViewContracts.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
import FirebaseAuth
protocol HomeViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput {

    case showAddProductModal
    case showLoading(Bool,String)
}

protocol HomeViewModelProtocol {
    var authListener: FireBaseAuthListenerProtocol? {get set}
    var databaseService: FirebaseDataBaseService? {get set}
    var delegate: HomeViewModelDelegate? { get set }
    var products: [Product]? {get set}
    func fetchOwnedProducts(completion: @escaping (Result<String,Error>) -> ())
    func deleteProduct(index: Int)
    func updateProduct(index: Int, product: Product, completion: @escaping ((Result<Bool,Error>) -> ()))
}
