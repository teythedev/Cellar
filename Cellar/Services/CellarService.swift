//
//  CellarService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 19.06.2023.
//

import Foundation

protocol CellarServiceProtocol {
    func getCellar(completion: @escaping (Result<Cellar,Error>) ->())
    func addProductToCellar()
    func deleteProductFromCellar()
    func updateProductInCellar()
}


final class FirebaseCellarService: CellarServiceProtocol {
    
    func getCellar(completion: @escaping (Result<Cellar, Error>) -> ()) {
        guard let currentCellarID = CellarUserManager.shared.cellarUser?.currentCellarID else {return}
        let firebaseDatabaseService = FirebaseDataBaseService.shared
        firebaseDatabaseService.getDocument(Cellar.self,collectionPath: Collections.cellars, documentID: currentCellarID) { result in
            switch result {
            case .success(let cellar):
                completion(.success(cellar))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addProductToCellar() {
        //TODO: -
    }
    
    func deleteProductFromCellar() {
        //TODO: -
    }
    
    func updateProductInCellar() {
        //TODO: -
    }
    
    
}
