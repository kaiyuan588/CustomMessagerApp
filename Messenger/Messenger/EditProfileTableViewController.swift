//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    
    //MARK - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        showUserInfo()
        
    }
    //MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView();
        headerView.backgroundColor = UIColor(named: "TableViewBackgoundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
}
