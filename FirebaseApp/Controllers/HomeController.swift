//
//  HomeController.swift
//  FirebaseNeon
//
//  Created by Taha Özmen on 14.03.2024.
//

import UIKit
import SnapKit
import Firebase
import SDWebImage

class HomeController: UIViewController, CustomTableViewCellDelegate {
    
    
    
    
    var userEmailArray = [String]()
    var userDescArray = [String]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorColor = .black
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.height * 0.75
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
            return tableView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getDataFromFirestore()
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        
        
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func getDataFromFirestore () {
        let firestoreDb = Firestore.firestore()
        
        firestoreDb.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userDescArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postDescription") as? String {
                            self.userDescArray.append(postComment)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func commentsButtonClicked(atIndexPath indexPath: IndexPath) {
        print("qweqwe")
    }
    
    @objc func commentTapped(_ sender: UIImageView) {
        guard let cell = sender.superview?.superview as? PostCell,
              let indexPath = tableView.indexPath(for: cell) else {return}
        showCommentsPanel(at: indexPath)
        
    }
    
    func showCommentsPanel(at indexPath: IndexPath) {
        let commentVC = CommentsViewController()
        commentVC.postId = documentIdArray[indexPath.row]
        present(commentVC, animated: true, completion: nil)
    }
    
}

extension HomeController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.detailLabel.text = userDescArray[indexPath.row]
        cell.commentButton.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        
        cell.postImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        return cell
    }
}
