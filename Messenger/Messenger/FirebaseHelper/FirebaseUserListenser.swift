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
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil && authDataResult!.user.isEmailVerified{
                FirebaseUserListenser.shared.downloadUserFromFirbase(userId: authDataResult!.user.uid, email: email)
                completion(error, true)
            }else {
                print("email is not verified")
                completion(error, false)
            }
            
        }
    }
    
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
                    
                    saveUserLocally(user: user)
                    
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    //MARK -SAVE USERS
    func saveUserToFirestore(_ user: User){
        
        do {
            try FirebaseReference(.User).document(user.id).setData(from: user)
        }catch {
            print("adding suer error \(error.localizedDescription)")
        }
    }
    
    //MARK -Download User from firebase
    func downloadUserFromFirbase(userId: String, email: String? = nil) {
        FirebaseReference(.User).document(userId).getDocument { (querySnapShot, error) in
            guard let document = querySnapShot else {
                print("no document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject) :
                if let user = userObject {
                    saveUserLocally(user: user)
                }else {
                    print("Document does not exist")
                }
            case .failure(let error) :
                print("error decoding user \(error.localizedDescription)")
            }
        }
    }
}
