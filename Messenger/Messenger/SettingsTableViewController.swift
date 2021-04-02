//
//  SettingsTableViewController.swift
//  Messenger
//
//  Created by 低调 on 4/1/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    //MARK - IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //MARK - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    
    //MARK - TableView delegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView();
        headerView.backgroundColor = UIColor(named: "TableViewBackgoundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    //MARK -IBActions
    
    @IBAction func tellfriendTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func termsConditionBtnPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        
        
    }
    
    //MARK - UpdateUI
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameLabel.text = user.userName
            statusLabel.text = user.status
            appVersionLabel.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != "" {
                //download and set avatarlink
                
            }
        }
    }
}
