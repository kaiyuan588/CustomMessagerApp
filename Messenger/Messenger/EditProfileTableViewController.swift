//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {

    
    //MARK - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    //MARK - vars
    var gallery : GalleryController!
    
    //MARK - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureTextField()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    
    //MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView();
        headerView.backgroundColor = UIColor(named: "TableViewBackgoundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: Show status view
        
    }
    
    //MARK -IBActions
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        showImageGallery()
    }
    
    //MARK - Update UI

    private func showUserInfo() {
        if let user = User.currentUser {
            usernameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                //set avatar
                
            }
        }
    }
    
    //MARK - Configure
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK - Gallery
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }
    //MARK - Upload Images
    private func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        
        FireStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            if var user = User.currentUser{
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user: user)
                FirebaseUserListenser.shared.saveUserToFirestore(user)
            }
            
            //TODO: save image locally
            
        }
    }
}

extension EditProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.userName = textField.text!
                    saveUserLocally(user: user)
                    FirebaseUserListenser.shared.saveUserToFirestore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            
            images.first!.resolve { (avatarImage) in
                if avatarImage != nil {
                //TODO: Upload image
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageView.image = avatarImage
                
                }else {
                    ProgressHUD.showError("Could not select image")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
