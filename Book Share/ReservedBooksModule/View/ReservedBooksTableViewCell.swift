//
//  ReservedBooksTableViewCell.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

class ReservedBooksTableViewCell: UITableViewCell {

    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.orange
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [bookImage, authorLabel, publishDateLabel, genreLabel, titleLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        bookImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
        
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
       
        
        genreLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5).isActive = true
        genreLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
        
        
        publishDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5).isActive = true
        publishDateLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
        publishDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }

}
