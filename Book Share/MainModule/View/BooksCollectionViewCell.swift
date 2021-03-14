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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var rentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
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
    
    lazy var viewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 4)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.clipsToBounds = true
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
        
        [bookImage, authorLabel, titleLabel, rentImage].forEach {
            viewCell.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        viewCell.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        viewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
       
        bookImage.topAnchor.constraint(equalTo: viewCell.topAnchor).isActive = true
        bookImage.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor).isActive = true
        bookImage.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        rentImage.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 5).isActive = true
        rentImage.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor).isActive = true
        rentImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rentImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        rentImage.bringSubviewToFront(viewCell)
        
        titleLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor ,constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -5).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor ,constant: 10).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 125).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -10).isActive = true
        
    }
}
