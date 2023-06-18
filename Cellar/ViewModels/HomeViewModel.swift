//
//  HomeViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
import FirebaseAuth
final class HomeViewModel: HomeViewModelProtocol {
 
    var authListener: FireBaseAuthListenerProtocol?
    
    var databaseService: FirebaseDataBaseService?
    
    func updateProduct(index: Int, product: Product, completion: @escaping ((Result<Bool, Error>) -> ())) {
        //TODO: Service.updateProduct
        guard var products = products else {return}
        products[index] = product
        completion(.success(true))


    }
    
    
    func deleteProduct(index: Int) {
        delegate?.handleViewModelOutput(.showLoading(true, "Product Deleting"))
        products?.remove(at: index)
        delegate?.handleViewModelOutput(.showLoading(false, ""))
    }
    
    func fetchOwnedProducts(completion: @escaping (Result<String, Error>) -> ()) {
        delegate?.handleViewModelOutput(.showLoading(true, "Products Loading"))
        //TODO: Service.fetchProduct Method here
       
        products = Temps.products

        completion(.success("Success"))
        delegate?.handleViewModelOutput(.showLoading(false,""))
    }
    
    func gotoAddProductViewController() {
        
    }
    
    var products: [Product]?
    
    
    var delegate: HomeViewModelDelegate?
    
    private var isUserLoggedIn = false

    
}
