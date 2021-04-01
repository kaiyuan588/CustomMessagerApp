//
//  FirebaseUserListenser.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import Foundation
import Firebase

class FirebaseUserListenser {
    static let shared = FirebaseUserListenser()
    
    private init() {}
    
    //MARK: -LOGIN
    
    
    //MARK: -REGISTER
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(error)
            
            if error == nil {
                //send verification email
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email sent error \(error?.localizedDescription)")
                }
                //create user and save
                if authDataResult?.user != nil {
                    let user = User(id: authDataResult!.user.uid, userName: email, email: email, pushId: "", avatarLink: "", status: "Hey there I'm using messager")
                }
            }
        }
    }
}
