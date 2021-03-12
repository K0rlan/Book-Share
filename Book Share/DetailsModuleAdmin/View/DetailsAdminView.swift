//
//  DetailsAdminView.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import UIKit


class DetailsAdminView: UIView {
    
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
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var availableLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.backgroundColor = Constants.orange
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.layer.borderColor = Constants.orange.cgColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 3, height: 4)
        label.textAlignment = .center
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.1
        label.text = "Available"
        label.textColor = .white
        return label
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
    
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also"
        label.textColor = Constants.dark
        label.alpha = 0
        label.numberOfLines = 0
        return label
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
    
    var delegate: DetailsViewProtocol!
    
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
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch bookData {
        case .initial:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .loading:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .success(let success):
            self.isHidden = true
            self.update(viewData: success)
            activityIndicator.isHidden = true
        case .successImage(let success):
            self.updateImage(image: success)
            self.isHidden = false
            activityIndicator.isHidden = true
        case .bookStatus(let status):
            activityIndicator.isHidden = true
            self.isHidden = false
        if status == BookStatus.available {
            bringSubviewToFront(availableLabel)
            availableLabel.isHidden = false
            availableLabel.isEnabled = true
            notAvailableLabel.isHidden = true
            notAvailableLabel.isEnabled = false
        }else if status == BookStatus.notAvailable {
            bringSubviewToFront(notAvailableLabel)
            notAvailableLabel.isHidden = false
            notAvailableLabel.isEnabled = true
            availableLabel.isHidden = true
            availableLabel.isEnabled = false
        }
        case .failure:
            activityIndicator.isHidden = true
        }
    }
    
    private func update(viewData: DetailsData.Data?){
        guard let data = viewData  else { return }
        titleLabel.text = data.title
        authorLabel.text = data.author
        publishDateLabel.text = data.publish_date
        notAvailableLabel.alpha = 1
        availableLabel.alpha = 1
        descriptionLabel.alpha = 1
        
    }
    private func updateImage(image: UIImage){
        bookImage.image = image
        bookImage.alpha = 1
    }
    
    
    private func setupViews() {
        [bookImage, authorLabel, publishDateLabel, genreLabel, titleLabel, activityIndicator, descriptionLabel, availableLabel, notAvailableLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.widthAnchor.constraint(equalToConstant: 105).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        
        genreLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5).isActive = true
        genreLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        
        publishDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5).isActive = true
        publishDateLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        
        availableLabel.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        availableLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        availableLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        availableLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        notAvailableLabel.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        notAvailableLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        notAvailableLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        notAvailableLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 50).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    }
    
}