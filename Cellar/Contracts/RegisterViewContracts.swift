//
//  RegisterViewContracts.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    
    func handleViewModelOutput(_ output: RegisterViewModelOutput)
    
}

enum RegisterViewModelOutput {
    case showLoading(Bool,String)
    case userRegistered(Bool,String)
}


protocol RegisteViewModelProtocol {
    var delegate: RegisterViewModelDelegate? { get set }
    
    var authService: AuthServiceProtocol? { get set }
    
    //var databaseService: FirebaseDataBaseService? {get set}
    var cellarUserService: CellarUserServiceProtocol? {get set}
    
    var isFormValid: Bindable<Bool> { get set }
    
    var email: String? { get set }
    
    var password: String? { get set }
    
    var name: String? { get set }
    
    var surname: String? { get set }
    
    func performRegister()
    
    
}
