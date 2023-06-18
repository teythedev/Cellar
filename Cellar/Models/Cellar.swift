//
//  Cellar.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 7.06.2023.
//

import Foundation
struct Cellar: DatabaseObject{
    var id: String
    let name: String
    let products: [Product]
    let cellarUsersIDs: [String]
    var lastUpdated: Date
}
