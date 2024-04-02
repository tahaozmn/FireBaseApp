//
//  CustomCommentCell.swift
//  NeonAppsFirebase
//
//  Created by Taha Özmen on 20.03.2024.
//

import UIKit
import SnapKit

class CustomCommentCell: UITableViewCell {
    
    static let reuseID = "commentsCell"
    var mailLabel = UILabel()
    var commentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupUI() {
         self.backgroundColor = .white
         
         mailLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
         mailLabel.textColor = .black
         mailLabel.text = "mailLabel"
         addSubview(mailLabel)
         mailLabel.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(20)
             make.leading.equalTo(20)
         }
         
         commentLabel.font = UIFont.systemFont(ofSize: 16)
         commentLabel.text = "comment"
         commentLabel.textColor = .black
         addSubview(commentLabel)
         commentLabel.snp.makeConstraints { make in
             make.top.equalTo(mailLabel.snp.bottom).offset(20)
             make.width.equalToSuperview().inset(10)
             make.bottom.equalToSuperview().inset(20)
             make.leading.equalTo(20)
         }
    }
}
