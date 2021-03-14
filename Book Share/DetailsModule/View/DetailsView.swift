//
//  DetailsView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 03.03.2021.
//

import Foundation
import UIKit

protocol DetailsViewProtocol {
    func addRentButtonPressed()
    func deleteRentButtonPressed()
    func getRole(role: RolesViewData.Roles)
    func deleteComment(id: Int)
    func updateComment(id: Int, text: String)
    func isBookNotAvailable(flag: Bool)
}

class DetailsView: UIView {
    
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.1
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = Constants.dark
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.orange
        label.numberOfLines = 0
        return label
    }()
    
    lazy var publishDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.dark
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = Constants.dark
        label.numberOfLines = 0
        label.alpha = 0
        label.text = "Comments:"
        return label
    }()
    
    
    lazy var reserveBookButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.orange
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.alpha = 0
        button.layer.borderColor = Constants.orange.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 4)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.1
        button.setTitle("Take a book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(reserveBookButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var notAvailableLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.backgroundColor = Constants.dark
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.layer.borderColor = Constants.dark.cgColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 3, height: 4)
        label.textAlignment = .center
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.1
        label.text = "Not available"
        label.textColor = .white
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.gray
        view.alpha = 0
        return view
    }()
    
    lazy var returnBookButton: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.backgroundColor = Constants.dark
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.dark.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 4)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.1
        button.setTitle("Return a book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(returnBookButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "comments")
        tableView.layer.cornerRadius = 14
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var bookData: DetailsData = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var userRoles: RolesViewData = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    var commentsData: CommentResponse = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    var delegate: DetailsViewProtocol!
    var comments = [BooksComments]()
    var role: RolesViewData.Roles?
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setStyles()
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyles(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: -4)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.1
        
    }
    
    @objc func reserveBookButtonPressed(sender: UIButton){
        delegate?.addRentButtonPressed()
        sender.isHidden = true
        returnBookButton.isHidden = false
        returnBookButton.isEnabled = true
        sender.isEnabled = false
        
    }
    
    @objc func returnBookButtonPressed(sender: UIButton){
        delegate?.deleteRentButtonPressed()
        sender.isHidden = true
        reserveBookButton.isHidden = false
        reserveBookButton.isEnabled = true
        sender.isEnabled = false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch bookData {
        case .initial:
            activityIndicator.isHidden = false
        case .loading:
            activityIndicator.isHidden = false
        case .success(let success):
            self.update(viewData: success)
            activityIndicator.isHidden = true
        case .successImage(let success):
            self.updateImage(image: success)
            self.isHidden = false
            activityIndicator.isHidden = true
        case .bookStatus(let status):
            self.isHidden = false
            if status == BookStatus.available {
                bringSubviewToFront(reserveBookButton)
                reserveBookButton.isHidden = false
                reserveBookButton.isEnabled = true
                returnBookButton.isHidden = true
                notAvailableLabel.isHidden = true
                returnBookButton.isEnabled = false
                notAvailableLabel.isEnabled = false
                
            } else if status == BookStatus.canReturnBook {
                bringSubviewToFront(returnBookButton)
                returnBookButton.isHidden = false
                returnBookButton.isEnabled = true
                reserveBookButton.isHidden = true
                notAvailableLabel.isHidden = true
                reserveBookButton.isEnabled = false
                notAvailableLabel.isEnabled = false
                
            }else if status == BookStatus.notAvailable {
                bringSubviewToFront(notAvailableLabel)
                delegate.isBookNotAvailable(flag: true)
                notAvailableLabel.isHidden = false
                notAvailableLabel.isEnabled = true
                reserveBookButton.isHidden = true
                returnBookButton.isHidden = true
                returnBookButton.isEnabled = false
                reserveBookButton.isEnabled = false
                
            }
            
        case .failure(_):
            activityIndicator.isHidden = true
        }
        
        switch userRoles {
        case .success(let success):
            delegate?.getRole(role: success)
            role = success
            print(success)
        case .failure(let err):
            print(err)
        case .initial:
            activityIndicator.isHidden = false
        case .loading:
            activityIndicator.isHidden = false
        }
        
        switch commentsData {
        case .success(let success):
            comments = success
            tableView.reloadData()
            print(success)
        case .failure(let err):
            print(err)
        case .initial:
            tableView.reloadData()
        case .loading:
            tableView.reloadData()
        }
    }
    
    private func update(viewData: DetailsData.Data?){
        guard let data = viewData  else { return }
        activityIndicator.isHidden = true
        titleLabel.text = data.title
        authorLabel.text = data.author
        publishDateLabel.text = data.publish_date
        notAvailableLabel.alpha = 1
        returnBookButton.alpha = 1
        reserveBookButton.alpha = 1
        commentsLabel.alpha = 1
        separatorView.alpha = 1
        
    }
    private func updateImage(image: UIImage){
        bookImage.image = image
        bookImage.alpha = 1
    }
    
    private func setupViews() {
        [bookImage, authorLabel, publishDateLabel, titleLabel, activityIndicator, reserveBookButton, returnBookButton, notAvailableLabel, tableView, commentsLabel, separatorView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.widthAnchor.constraint(equalToConstant: 105).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        publishDateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10).isActive = true
        publishDateLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        publishDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        reserveBookButton.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        reserveBookButton.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        reserveBookButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        returnBookButton.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        returnBookButton.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        returnBookButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        notAvailableLabel.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        notAvailableLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        notAvailableLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        notAvailableLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        commentsLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20).isActive = true
        commentsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        commentsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        commentsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.bringSubviewToFront(self)
        
    }
    
}
extension DetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentsTableViewCell
        cell.delegate = self
        
        cell.userNameLabel.text = comments[indexPath.row].user_name
        cell.commentTextField.text = comments[indexPath.row].text
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.getId(id: comments[indexPath.row].id)
        if role?.role == "admin" {
            cell.admin()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
}
extension DetailsView: CommentsTableViewCellProtocol {
    func deleteButtonPressed(id: Int) {
        delegate.deleteComment(id: id)
        tableView.reloadData()
    }
    
    func updateButtonPressed(id: Int, text: String) {
        delegate.updateComment(id: id, text: text)
        tableView.reloadData()
    }
    
    
}
