//
//  CellarService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 19.06.2023.
//

import Foundation

protocol CellarServiceProtocol {
    func getCellars()
    func getCellar() -> Cellar?
    func addProductToCellar()
    func deleteProductFromCellar()
    func updateProductInCellar()
    
    var firebaseDatabaseService: FirebaseDataBaseService? {get set}
}


final class CellarService: CellarServiceProtocol {
    var firebaseDatabaseService: FirebaseDataBaseService?
    
    
    func getCellars() {
        
    }
    
    func getCellar() -> Cellar? {
        guard let firebaseDatabaseService = firebaseDatabaseService else {return nil}
        firebaseDatabaseService.getDocument(Cellar.self,collectionPath: Collections.cellars, documentID: "") { result in
            switch result {
            case .success(let success):
                return nil
            case .failure(let failure):
                return nil
            }
        }
    }
    
    func addProductToCellar() {
        <#code#>
    }
    
    func deleteProductFromCellar() {
        <#code#>
    }
    
    func updateProductInCellar() {
        <#code#>
    }
    
    
}
