//
//  CommentsTableViewCell.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = Constants.dark
        
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
//        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
//        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.gray
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    
    private  func setupViews() {
        [userNameLabel, commentLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        commentLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
}
