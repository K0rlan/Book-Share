//
//  MoreTableViewCell.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

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
    
    lazy var viewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 4)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.gray
        setupViews()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [viewCell].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [bookImage, authorLabel, publishDateLabel, genreLabel, titleLabel].forEach {
            viewCell.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        viewCell.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        viewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        viewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        bookImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        bookImage.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 10).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 10).isActive = true
        bookImage.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
       
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
       
        genreLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5).isActive = true
        genreLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
       
        publishDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5).isActive = true
        publishDateLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10).isActive = true
        publishDateLabel.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor, constant: -10).isActive = true
    }
}
