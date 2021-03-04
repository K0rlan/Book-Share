//
//  ProfileView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

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
    
    var profileData: UserProfile = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
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
        [avaImage, nameLabel, surnameLabel, emailLabel, phoneLabel].forEach {
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

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch profileData {
        case .initial:
            activityIndicator.isHidden = false
        case .loading:
            activityIndicator.isHidden = false
        case .success(let success):
            activityIndicator.isHidden = true
            avaImage.image = success.image
            nameLabel.text = success.name
            surnameLabel.text = success.surname
            emailLabel.text = success.email
            phoneLabel.text = String(success.phone)
        case .failure:
            activityIndicator.isHidden = true
        }
    }
}
