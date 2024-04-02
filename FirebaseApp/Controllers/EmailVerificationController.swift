//
//  EmailVerificationController.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 19.03.2024.
//

import UIKit
import SnapKit
import Firebase

class EmailVerificationController: UIViewController {
    
    
    private let headerView = AuthHeaderView(title: "Write Email", subTitle: "Email Verification")
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let sendButton = CustomButton(title: "Send", hasBackground: true, fontSize: .big)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)

        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(sendButton)
        
        
        self.emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        
    }
    
    @objc private func didTapSendButton() {
        
        if emailField.text != nil {
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                if error != nil {
                    self.makeAlert(title: "Error", message: "Failed: \(error?.localizedDescription ?? "Error")")
                } else {
                    let vc = LoginController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            makeAlert(title: "Error", message: "Enter an Email!")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
