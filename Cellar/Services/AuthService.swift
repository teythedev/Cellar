//
//  AuthService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 28.05.2023.
//

import Foundation
import FirebaseAuth
protocol AuthServiceProtocol{
    func loginWith(email: String, password: String, completion: @escaping ((Result<Any?,Error>) -> ()))
    func registerWith(email:String, password: String, completion: @escaping ((Result<Any?,Error>) -> ()))
}


final class FirebaseAuthService: AuthServiceProtocol {
    
    
    func loginWith(email: String, password: String, completion: @escaping ((Result<Any?, Error>) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user))
            }
        }
    }
    
    func registerWith(email: String, password: String, completion: @escaping ((Result<Any?, Error>) -> ())) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user))
            }
        }
    }
    
    
}
