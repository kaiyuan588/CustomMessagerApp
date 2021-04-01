//
//  ViewController.swift
//  Messenger
//
//  Created by 低调 on 3/31/21.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: -IBoutlets
    //Labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    
    //TextFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    //Buttons
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var resendEmailBtn: UIButton!
    
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    
    //MARK: -View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - IBAction
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        
    }
    @IBAction func resendEmailBtnPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        
    }
    
}

