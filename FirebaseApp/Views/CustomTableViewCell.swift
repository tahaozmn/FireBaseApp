//
//  CustomTableViewCell.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 19.03.2024.
//

import UIKit
import SnapKit
import Firebase
import SDWebImage

protocol CustomTableViewCellDelegate: AnyObject {
    func commentsButtonClicked(atIndexPath indexPath: IndexPath)
}

class PostCell: UITableViewCell {
    
  static let reuseID = "PostCell"
    
    weak var delegate: CustomTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    private var isLiked = false
    
    let emailLabel = UILabel()
    let detailLabel = UILabel()
    
    private let avatarImageView = UIImageView()
    let postImageView = UIImageView()
    private let likeImageView = UIImageView()
    let commentButton = UIButton()
    private let shareImageView = UIImageView()
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  private func configure() {
      
    addSubviews(avatarImageView, emailLabel, detailLabel)
    contentView.addSubviews(postImageView, commentButton)
      
      commentButton.setImage(UIImage(systemName: "captions.bubble.fill"), for: .normal)
      commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
      
      
      postImageView.contentMode = .scaleAspectFit
      postImageView.backgroundColor = .clear
      
      detailLabel.font = .boldSystemFont(ofSize: 18)
      
    avatarImageView.image = UIImage(systemName: "person.circle.fill")
    likeImageView.image = UIImage(systemName: "heart")
    shareImageView.image = UIImage(systemName: "location.fill")
      
      
    avatarImageView.tintColor = .lightGray
    likeImageView.tintColor = .label
    shareImageView.tintColor = .label
      
    selectionStyle = .none
      
      
    let padding: CGFloat = 16
      
    avatarImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(padding)
      make.width.height.equalTo(40)
    }
    emailLabel.snp.makeConstraints { make in
      make.centerY.equalTo(avatarImageView.snp.centerY).offset(-3)
      make.leading.equalTo(avatarImageView.snp.trailing).offset(padding)
      make.trailing.equalToSuperview()
    }
    postImageView.snp.makeConstraints { make in
      make.top.equalTo(avatarImageView.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.height.equalTo(450)
    }

    detailLabel.snp.makeConstraints { make in
        make.top.equalTo(postImageView.snp.bottom).offset(10)
        make.leading.equalTo(avatarImageView.snp.leading)
        make.width.equalTo(150)
        make.height.equalTo(30)
    }
      commentButton.snp.makeConstraints { make in
          make.top.equalTo(detailLabel.snp.bottom).offset(15)
          make.leading.equalTo(avatarImageView.snp.leading)
          make.height.width.equalTo(30)
      }
  }
    
  @objc func commentButtonTapped() {
      
      guard let indexPath else {return}
      
      delegate?.commentsButtonClicked(atIndexPath: indexPath)
      
  }
    
}
