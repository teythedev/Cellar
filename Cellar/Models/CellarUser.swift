//
//  User.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//
import Foundation

class CellarUser: DatabaseObject{
    let id: String
    let name: String?
    let cellarsIDs: [String]?
    let currentCellarID: String?
    let userEmail: String?
    var lastUpdated: Date
    
    init(id: String, name: String?, cellarsIDs: [String]? = nil, currentCellarID: String? = nil, userEmail: String?, lastUpdate: Date) {
        self.id = id
        self.name = name
        self.cellarsIDs = cellarsIDs
        self.currentCellarID = currentCellarID
        self.userEmail = userEmail
        self.lastUpdated = lastUpdate
    }
}

