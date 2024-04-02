//
//  UploadPhotoController.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 18.03.2024.
//

import UIKit
import SnapKit
import Firebase
import FirebaseStorage


class UploadPhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let uploadButton = CustomButton(title: "Upload", hasBackground: true, fontSize: .big)
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "selectimage.png")
        iv.tintColor = .white
        return iv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.tintColor = .systemBlue
        tf.textAlignment = .center
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        
        tf.layer.cornerRadius = 11
        tf.backgroundColor = .secondarySystemBackground
        tf.keyboardType = .default
        
        //tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        //tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(string: "Type Something", attributes: [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        tf.autocapitalizationType = .sentences
        //tf.autocorrectionType = .default
        
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
        
        logoImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        logoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(logoImageView)
        self.view.addSubview(textField)
        self.view.addSubview(uploadButton)
        
        self.logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(300)
        }
        
        self.textField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        self.uploadButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        uploadButton.isHidden = true
    }
    
    @objc private func didTapUploadButton() {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("Media")
        
        
        if let data = logoImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postDescription": self.textField.text!, "date": FieldValue.serverTimestamp()] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.logoImageView.image = UIImage(named: "selectimage.png")
                                    self.textField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            
        }
    }
    
    @objc private func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        logoImageView.image = info[.originalImage] as? UIImage
        uploadButton.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
