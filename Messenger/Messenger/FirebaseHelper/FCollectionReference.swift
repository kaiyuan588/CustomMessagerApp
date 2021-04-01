//
//  FCollectionReference.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Recent
}
func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
