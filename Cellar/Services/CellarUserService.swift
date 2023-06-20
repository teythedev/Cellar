//
//  CellarUserService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 20.06.2023.
//

import Foundation

protocol CellarUserServiceProtocol {
    func getCellarUser(cellarUserID: String, completion: @escaping (Result<CellarUser,Error>) ->())
    func saveCellarUser(cellarUser: CellarUser,completion: @escaping (Result<CellarUser,Error>) ->())
    func updateCellarUser()
    func deleteCellarUser()
}

final class FirebaseCellarUserService: CellarUserServiceProtocol {
    func getCellarUser(cellarUserID: String, completion: @escaping (Result<CellarUser, Error>) -> ()) {
        let firebaseDatabaseService = FirebaseDataBaseService.shared
        firebaseDatabaseService.getDocument(CellarUser.self, collectionPath: Collections.users, documentID: cellarUserID) { result in
            switch result {
            case .success(let cellarUser):
                completion(.success(cellarUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveCellarUser(cellarUser: CellarUser, completion: @escaping (Result<CellarUser,Error>) ->()) {
        let firebaseDatabaseService = FirebaseDataBaseService.shared
        firebaseDatabaseService.addDocument(collectionPath: Collections.users, data: cellarUser) { result in
            switch result {
            case .success(let cellarUser):
                completion(.success(cellarUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateCellarUser() {
        //TODO: -
    }
    
    func deleteCellarUser() {
        //TODO: -
    }
    
    
}
