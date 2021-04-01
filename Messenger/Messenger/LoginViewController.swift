//
//  ViewController.swift
//  Messenger
//
//  Created by 低调 on 3/31/21.
//

import UIKit
import Foundation
import ProgressHUD

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
    
    //View
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    //MARK: -var
    
    var isLogin: Bool = true
    
    //MARK: -View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIFor(login: true)
        setupTextFieldDelegate()
        setupBackgroundTap()
    }

    
    //MARK: - IBAction
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        if isDataInputedFor(type: isLogin ? "login" : "registration") {
            isLogin ? loginUser() : registerUser()
        }else {
            ProgressHUD.showFailed("All fields are required")
        }
    }
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resetPassword()
        }else {
            ProgressHUD.showFailed("Email is required")
        }
        
    }
    @IBAction func resendEmailBtnPressed(_ sender: UIButton) {
        if isDataInputedFor(type: "password") {
            resendVerficationEmail()
        }else {
            ProgressHUD.showFailed("Email is required")
        }
        
    }
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    
    //MARK: -SET UP
    private func setupTextFieldDelegate() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changing text field")
        updatePlaceHolderLabels(textField: textField)
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    //MARK: -ANIMATION
    
    private func updateUIFor(login: Bool) {
        loginBtn.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signupBtn.setTitle(login ? "SignUp" : "Login", for: .normal)
        
        signUpLabel.text = login ? "Don't have an account" : "Have an account"
    
        UIView.animate(withDuration: 0.5, animations: {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLineView.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            
        })
    }
    
    private func updatePlaceHolderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = emailTextField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabelOutlet.text = passwordTextField.hasText ? "Password" : ""
        default:
            repeatPasswordLabelOutlet.text = repeatPasswordTextField.hasText ? "Repeat Password" : ""
        }
    }
    
    //MARK - HELPER
    private func isDataInputedFor(type: String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    private func registerUser() {
        if passwordTextField.text == repeatPasswordTextField.text {
            FirebaseUserListenser.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if let error = error  {
                    ProgressHUD.showError(error.localizedDescription)
                    print("Error when register \(error.localizedDescription)")
                }else {
                    ProgressHUD.showSuccess("Verification Email Sent")
                    self.resendEmailBtn.isHidden = false
                }
            }
        }else {
            ProgressHUD.showError("The Password don't match")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListenser.shared.resetPassword(email: emailTextField.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Reset link send to email")
            }else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerficationEmail() {
        FirebaseUserListenser.shared.resendVerificationEmail(email: emailTextField.text!, completion: { (error) in
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent")
            }else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        })
    }
    private func loginUser() {
        FirebaseUserListenser.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailisVerified) in
            if error == nil {
                if isEmailisVerified {
                    print("User has login \(User.currentUser!.email)")
                    
                    //Go to app
                    self.goToApp()
                }else {
                    ProgressHUD.showFailed("Please Verify Email")
                    self.resendEmailBtn.isHidden = false
                }
            }else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    //MARK -NAVIGATION
    
    private func goToApp(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

}

