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
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = Constants.orange
        label.backgroundColor = Constants.gray
        return label
    }()
    
    lazy var commentTextField: UITextView = {
        let textField = UITextView()
        textField.font = .boldSystemFont(ofSize: 16)
        textField.textColor = Constants.dark
        textField.backgroundColor = Constants.gray
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
    
    lazy var updateSubmitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.orange
        button.setTitle("Submit", for: .normal)
        button.setTitleColor( .white, for: .normal)
        button.isHidden = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.orange.cgColor
        button.addTarget(self, action: #selector(updateSubmitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.trash, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var delegate: CommentsTableViewCellProtocol!
    var id: Int!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
    }
    
    @objc func updateButtonPressed(){
        updateSubmitButton.isHidden = false
        self.reloadInputViews()
        commentTextField.isUserInteractionEnabled = true
    }
    
    @objc func updateSubmitButtonPressed(){
        delegate.updateButtonPressed(id: id, text: commentTextField.text!)
        self.reloadInputViews()
        updateSubmitButton.isHidden = true
    }
    
    
    private  func setupViews() {
        [userNameLabel, updateButton, deleteButton, commentTextField, updateSubmitButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        commentTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        commentTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        commentTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        
        updateSubmitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        updateSubmitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        updateSubmitButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        updateSubmitButton.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 5).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        updateButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        updateButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
}
