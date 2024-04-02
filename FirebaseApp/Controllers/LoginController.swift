//
//  LoginController.swift
//  FirebaseNeon
//
//  Created by Taha Özmen on 14.03.2024.
//

import UIKit
import SnapKit
import Firebase

class LoginController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Login to your account.")
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "Sign Up with a new account.", fontSize: .medium)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password ?", fontSize: .small)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPw), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        self.emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.newUserButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(60)
        }
        self.forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(newUserButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(60)
        }
        
    }
    
    @objc private func didTapSignIn() {
        
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    let vc = TabBarController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            self.makeAlert(title: "Error!", message: "Username / Password")
        }
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPw() {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }



}
