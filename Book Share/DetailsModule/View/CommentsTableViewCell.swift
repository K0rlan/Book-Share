//
//  CommentsTableViewCell.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import UIKit

protocol CommentsTableViewCellProtocol {
    func deleteButtonPressed(id: Int)
    func updateButtonPressed(id: Int, text: String)
}

class CommentsTableViewCell: UITableViewCell {
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = Constants.dark
        
        return label
    }()
    
    lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 22)
        textField.textColor = Constants.dark
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var delegate: CommentsTableViewCellProtocol!
    var id: Int!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.gray
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    public func admin(){
        deleteButton.isHidden = false
        updateButton.isHidden = false
    }
    
    public func getId(id: Int){
        self.id = id
    }
    
    @objc func deleteButtonPressed(){
        delegate.deleteButtonPressed(id: id)
        print(#function)
    }
    
    @objc func updateButtonPressed(){
        commentTextField.isUserInteractionEnabled = true
        delegate.updateButtonPressed(id: id, text: commentTextField.text!)
    }
    
    private  func setupViews() {
        [userNameLabel, updateButton, deleteButton, commentTextField].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        commentTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        commentTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
       updateButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
       updateButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5).isActive = true
       updateButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
}
