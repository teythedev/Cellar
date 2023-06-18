//
//  DatabaseService.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 1.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Collections: String {
    case users = "Users"
    case cellars = "Cellars"
    
}

protocol APIResource {
    associatedtype Response: DatabaseObject;
}

protocol DatabaseObject: Codable {
    var id: String {get}
    var lastUpdated: Date {get}
}

final class FirebaseDataBaseService {
    func getDocument<T: DatabaseObject>(
        _ t: T.Type,
        collectionPath: Collections,
        documentID: String,
        completion: @escaping ((Result<T,Error>) -> ())
    ) {
        let db = Firestore.firestore()
        db.collection(collectionPath.rawValue).document(documentID).getDocument(as: T.self) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func getDocuments<T: DatabaseObject>(
        collectionPath: Collections,
        completion: @escaping ((Result<[T],Error>) -> ())
    ) {
        let db = Firestore.firestore()
        db.collection(collectionPath.rawValue).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = querySnapshot?.documents {
                    var docs: [T] = []
                    for doc in documents {
                        if let dc = try? doc.data(as: T.self) {
                            docs.append(dc)
                        }else {
                            completion(.failure(NSError(domain: "Document convert error", code: 1)))
                            
                        }
                    }
                    completion(.success(docs))
                } else {
                    completion(.failure(NSError(domain: "No document error", code: 0)))
                }
            }
        }
    }
    
    func addDocument<T: DatabaseObject> (
        collectionPath: Collections,
        data: T,
        completion: @escaping ((Result<T,Error>) -> ())
    ){
        let db = Firestore.firestore()
        do {
            try db.collection(collectionPath.rawValue).document(data.id).setData(from: data, completion: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
            })
            
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updateDocument (
        collectionPath: Collections,
        documentID: String,
        updateFieldNamesAndValues: [String: Any],
        completion: @escaping ((Result<[String:Any],Error>) -> ())
    ) {
        let db = Firestore.firestore()
        db.collection(collectionPath.rawValue).document(documentID).updateData(updateFieldNamesAndValues) { error in
            if let error = error {
                completion(.failure(error))
            }else {
                completion(.success(updateFieldNamesAndValues))
            }
        }
        
    }
}
