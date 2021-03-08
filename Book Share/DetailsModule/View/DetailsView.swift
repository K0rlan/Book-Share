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
            reserveBookButton.alpha = 1
            returnBookButton.alpha = 1
            descriptionLabel.alpha = 1
            activityIndicator.isHidden = true
            self.update(viewData: success)
        case .successImage(let success):
            bookImage.alpha = 1
            returnBookButton.alpha = 1
            reserveBookButton.alpha = 1
            descriptionLabel.alpha = 1
            self.updateImage(image: success)
            activityIndicator.isHidden = true
        case .failure:
            activityIndicator.isHidden = true
        }
    }
    
    private func update(viewData: DetailsData.Data?){
        guard let data = viewData  else { return }
        titleLabel.text = data.title
        authorLabel.text = data.author
        publishDateLabel.text = data.publish_date
        
        do {
            try dbQueue.read { db in
                let draft = try Booking.filterByBookID(id: data.id).fetchAll(db)
                if draft.isEmpty{
                    returnBookButton.isHidden = true
                    bringSubviewToFront(reserveBookButton)
                    reserveBookButton.isHidden = false
                    reserveBookButton.isEnabled = true
                    returnBookButton.isEnabled = false
                }else {
                    reserveBookButton.isHidden = true
                    bringSubviewToFront(returnBookButton)
                    returnBookButton.isHidden = false
                    returnBookButton.isEnabled = true
                    reserveBookButton.isEnabled = false
                }
               
            }
        } catch {
            print("\(error)")
        }
        
    }
    private func updateImage(image: UIImage){
        bookImage.image = image
    }
    
    private func setupViews() {
        [bookImage, authorLabel, publishDateLabel, genreLabel, titleLabel, activityIndicator, descriptionLabel, reserveBookButton, returnBookButton].forEach {
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
        
        reserveBookButton.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        reserveBookButton.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        reserveBookButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        returnBookButton.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 10).isActive = true
        returnBookButton.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20).isActive = true
        returnBookButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 50).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    }
    
}
