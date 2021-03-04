//
//  BooksCollectionViewCell.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 14
//        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
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
    
    lazy var viewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 4)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
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
        
        [bookImage, authorLabel, titleLabel].forEach {
            viewCell.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        viewCell.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        viewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
       
        bookImage.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 10).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 10).isActive = true
        bookImage.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -10).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 170).isActive = true
//        bookImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor ,constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -5).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor ,constant: 20).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -10).isActive = true
        
    }
}
