//
//  LoginViewContract.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: LoginViewModelOutput)
    
}

enum LoginViewModelOutput {
    case userLoggedIn(Bool,String?)
    case showLoading(Bool,String)
}


protocol LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate? { get set }
    
    var authService: AuthServiceProtocol? { get set }
    
    var isFormValid: Bindable<Bool> { get set }
    
    var email: String? {get set}
    
    var password: String? {get set}
    
    func performLogin()
    
    
}
