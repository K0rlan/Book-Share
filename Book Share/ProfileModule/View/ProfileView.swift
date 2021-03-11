//
//  ProfileView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

protocol ProfileViewProtocol {
    func getBooksID(id: Int)
}


class ProfileView: UIView {
    
    lazy var avaImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.orange
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.gray
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "reading")
        tableView.layer.cornerRadius = 14
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    var profileData: UserProfile = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var bookImage: ViewImages = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var readingBooks: [UserProfile.RentsData] = []
    var delegate: ProfileViewProtocol!
    var images = [ViewImages.BooksImages]()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        [avaImage, nameLabel, surnameLabel, emailLabel, phoneLabel, tableView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        avaImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        avaImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        avaImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        avaImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avaImage.trailingAnchor, constant: 10).isActive = true
        
        surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        surnameLabel.leadingAnchor.constraint(equalTo: avaImage.trailingAnchor, constant: 10).isActive = true

        emailLabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 10).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: avaImage.trailingAnchor, constant: 10).isActive = true

        phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: avaImage.trailingAnchor, constant: 10).isActive = true
        
        tableView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch profileData {
        case .initial:
            activityIndicator.isHidden = false
            tableView.isHidden = true
        case .loading:
            activityIndicator.isHidden = false
            tableView.isHidden = true
        case .success(let success):
            avaImage.image = success.image
            nameLabel.text = success.name
            surnameLabel.text = success.surname
            emailLabel.text = success.email
            phoneLabel.text = String(success.phone)
        case .successReading(let success):
            activityIndicator.isHidden = true
            readingBooks = success
            tableView.isHidden = false
            
        case .failure:
            activityIndicator.isHidden = true
            tableView.isHidden = true
       
    }
        
        switch bookImage {
        case .initial:
            activityIndicator.isHidden = false
        case .loading:
            activityIndicator.isHidden = false
        case .successImage(let success):
            images = success
            tableView.isHidden = false
            activityIndicator.isHidden = true
            tableView.reloadData()
        case .failure:
            tableView.isHidden = false
            activityIndicator.isHidden = true
        }
}
}
extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingBooks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reading", for: indexPath) as! ProfileTableViewCell
        let book = readingBooks[indexPath.row].book!
        cell.backgroundColor = Constants.gray
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.publishDateLabel.text = book.publish_date
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        cell.bookImage.image = .none
        
            for image in self.images {
            if book.id == image.id {
                cell.bookImage.image = UIImage(data: image.image!)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookID = readingBooks[indexPath.row].book?.id
        delegate.getBooksID(id: bookID!)
    }
    
}

