//
//  AuthService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 28.05.2023.
//

import Foundation
import FirebaseAuth

typealias FirebaseAuthUser = FirebaseAuth.User

protocol AuthServiceProtocol{
    func loginWith(email: String, password: String, completion: @escaping ((Result<CellarUser?,Error>) -> ()))
    func registerWith(email:String, password: String, completion: @escaping ((Result<CellarUser?,Error>) -> ()))
}

protocol FireBaseAuthListenerProtocol {
    func addAuthUserListener(completion: @escaping (FirebaseAuthUser?) -> ())
    func removeAuthUserListener()
    var authHandler: AuthStateDidChangeListenerHandle? {get set}
}

final class FireBaseAuthListerner: FireBaseAuthListenerProtocol {
    var authHandler: AuthStateDidChangeListenerHandle?
    
    func addAuthUserListener(completion: @escaping (FirebaseAuthUser?) -> ()) {
        authHandler = Auth.auth().addStateDidChangeListener({auth, user in
            completion(user)
        })
    }
    func removeAuthUserListener() {
        if authHandler != nil {
            Auth.auth().removeStateDidChangeListener(authHandler!)
        }
        
    }
}

final class FirebaseAuthService: AuthServiceProtocol {
    
    enum FireBaseAuthError: String,Error {
        case NilUserError = "Nil User"
    }
    
    func loginWith(email: String, password: String, completion: @escaping ((Result<CellarUser?, Error>) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                
                if let user = result?.user {
                    let cellarUser = CellarUser(id: user.uid, name: user.displayName, cellarsIDs: nil, userEmail: user.email, lastUpdate: Date.now)
                   completion(.success(cellarUser))
                }else {
                    completion(.failure(FireBaseAuthError.NilUserError))
                }
            }
        }
    }
    
    func registerWith(email: String, password: String, completion: @escaping ((Result<CellarUser?, Error>) -> ())) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let user = result?.user {
                    let cellarUser = CellarUser(id: user.uid, name: user.displayName, cellarsIDs: nil, userEmail: user.email, lastUpdate: Date.now)
                    completion(.success(cellarUser))
                }else {
                    completion(.failure(FireBaseAuthError.NilUserError))
                }
            }
        }
    }
}
