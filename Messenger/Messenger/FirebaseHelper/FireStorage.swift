//
//  FireStorage.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import Foundation
import FirebaseStorage
import ProgressHUD


let storage = Storage.storage()

class FireStorage {
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        let storageReference = storage.reference(forURL: kFILEREFERENCE).child(directory)
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        var task: StorageUploadTask!
        
        task = storageReference.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error uploading image \(error!.localizedDescription)")
                return
            }
            
            storageReference.downloadURL { (url, error) in
                
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
            
        })
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            
            let progross = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(progross))
        }
        
    }
}
