//
//  ForgotPasswordController.swift
//  FirebaseNeon
//
//  Created by Taha Özmen on 14.03.2024.
//

import UIKit
import SnapKit
import Firebase

class ForgotPasswordController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Forgot Password", subTitle: "Reset your password.")
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let resetPasswordButton = CustomButton(title: "Reset Password", hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapResetPw), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        
        self.emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
    }
    
    @objc private func didTapResetPw() {
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
            if let error = error {
                print("Couldn't Send Password Reset: \(error.localizedDescription)")
            } else {
                print("Sent Successfully")
            }
        }
        
    }

    

}
