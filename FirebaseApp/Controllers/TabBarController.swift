//
//  TabBarController.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 18.03.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()

        //self.tabBar.barTintColor = .red
        self.tabBar.tintColor = .orange
        self.tabBar.unselectedItemTintColor = .purple
    }
    
    // MARK: - Tab Setup
    
    private func setupTabs() {
        let home = self.createNav(title: "Home", image: UIImage(systemName: "house"), vc: HomeController())
        let upload = self.createNav(title: "Upload", image: UIImage(systemName: "square.and.arrow.up"), vc: UploadPhotoController())
        let settings = self.createNav(title: "Settings", image: UIImage(systemName: "gear"), vc: SettingsController())
        
        self.setViewControllers([home,upload,settings], animated: true)
    }
    
    private func createNav(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title.uppercased()
//        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
    }
    

   

}
