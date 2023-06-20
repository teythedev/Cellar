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


protocol DatabaseObject: Codable {
    var id: String {get}
    var lastUpdated: Date {get}
}

final class FirebaseDataBaseService {
    
    static let shared = FirebaseDataBaseService()
    
    private init(){}
        
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
    
    func getDocumentsWithIsEqualTo<T: DatabaseObject>(
        _ t: T.Type,
        collectionPath: Collections,
        whereField: String,
        isEqualTo: Any,
        completion: @escaping ((Result<[T],Error>) -> ())
    ) {
        let db = Firestore.firestore()
        db.collection(collectionPath.rawValue).whereField(whereField, isEqualTo: isEqualTo).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var resultArray: [T] = []
                guard let documents = snapshot?.documents else {
                    completion(.failure(NSError(domain: "Document Error", code: 0)))
                    return
                }
                for document in documents {
                    do {
                        let data = try document.data(as: T.self)
                        resultArray.append(data)
                    }catch let error {
                        completion(.failure(error))
                    }
                }
                completion(.success(resultArray))
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


