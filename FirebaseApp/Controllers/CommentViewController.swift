//
//  CommentViewController.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 20.03.2024.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.tintColor = .systemBlue
        tf.textAlignment = .center
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        
        tf.layer.cornerRadius = 11
        tf.backgroundColor = .secondarySystemBackground
        tf.keyboardType = .decimalPad
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(string: "Type your comment", attributes: [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        
        return tf
    }()
    
    let commentTableView = UITableView()
    var comments = [String]()
    var userEmails = [String]()
    var postId = String()
    //var commentTf = UITextField()
    var sendButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCommentsFromFirestore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        getCommentsFromFirestore()
    }
    
    func setupTableView(){
        
        view.backgroundColor = .white
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(CustomCommentCell.self, forCellReuseIdentifier: CustomCommentCell.reuseID)
        view.addSubview(commentTableView)
        
        commentTableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
//        commentTf.backgroundColor = .systemGray2
//        commentTf.textColor = .black
//        commentTf.leftViewMode = .always
//        commentTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: commentTf.frame
//            .height))
        
        view.addSubview(commentTextField)
        
        commentTextField.snp.makeConstraints { make in
            //
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().inset(25)
            make.width.equalTo(300)
            make.height.equalTo(80)
            
        }
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendClicked), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(25)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    @objc func sendClicked(){
        guard let commentText = commentTextField.text, !commentText.isEmpty else {
            return
        }
        guard let userId = Auth.auth().currentUser?.email else {
            return
        }
        let comment = commentText
        let db = Firestore.firestore()
        let commentsCollection = db.collection("posts").document(postId).collection("comments")
        commentsCollection.addDocument(data: [
            "comment": comment,
            "timestamp": FieldValue.serverTimestamp(),
            "email": userId
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.getCommentsFromFirestore()
            }
        }
        commentTextField.text = ""
    }
    
    func getCommentsFromFirestore(){
        let db = Firestore.firestore()
        let commentCollection = db.collection("posts").document(postId).collection("comments")
        commentCollection.getDocuments { snapshot, error in
            if error != nil {
                if let error = error {
                    print("error getting comments: \(error)")
                    return
                }
            } else {
                guard let snapshot = snapshot else {
                    print("snapshot nil")
                    return
                }
                if snapshot.isEmpty {
                    print("snapshot empty")
                }
                self.comments.removeAll()
                self.userEmails.removeAll()
                //self.postId.removeAll()
                print("snapshot: \(snapshot.documents)")
                for document in snapshot.documents {
                    //          let documentID = document.documentID
                    //          self.postId.append(documentID)
                    if let comment = document.data()["comment"] as? String {
                        self.comments.append(comment)
                    }
                    if let userEmail = document.data()["email"] as? String {
                        self.userEmails.append(userEmail)
                    }
                }
                DispatchQueue.main.async {
                    self.commentTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("comments count: \(comments.count)")
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCommentCell.reuseID, for: indexPath) as! CustomCommentCell
        cell.mailLabel.text = userEmails[indexPath.row]
        cell.commentLabel.text = comments[indexPath.row]
        return cell
    }
}
