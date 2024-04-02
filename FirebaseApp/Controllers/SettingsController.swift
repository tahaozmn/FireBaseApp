//
//  SettingsController.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 18.03.2024.
//

import UIKit
import SnapKit
import Firebase

class SettingsController: UIViewController {
    
    private let logOutButton = CustomButton(title: "Log Out", hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.logOutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(logOutButton)
        
        self.logOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
    }
    
    @objc private func didTapLogout() {
        
        do {
            try Auth.auth().signOut()
            let vc = LoginController()
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            print("error")
        }

    }

}
