//
//  BookTableViewCell.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import UIKit

protocol BookTableViewCellDelegate{
    func showDetails(id: Int)
    func moreBooks(id: Int)
}

class BookTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = Constants.dark
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("More", for: .normal)
        button.setTitleColor(Constants.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.register(BooksCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = Constants.gray
        return collectionView
    }()
    
    var books = [ViewData.BooksData]()
    
    var id: Int!
    var images: [ViewImages.BooksImages] = []
    var delegate: BookTableViewCellDelegate!
    var rents = [BookRent]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Constants.gray
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func updateCV(books: [ViewData.BooksData], id: Int, images: [ViewImages.BooksImages], rents: [BookRent]){
        self.books = books
        collectionView.reloadData()
        self.id = id
        self.images = images
        self.rents = rents
    }
    
    
    private  func setupViews() {
        [collectionView, moreButton, titleLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        moreButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
    @objc func moreButtonPressed(){
        delegate.moreBooks(id: self.id)
    }
}
extension BookTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BooksCollectionViewCell
        let book = books[indexPath.row]
        cell.bookImage.image = UIImage(contentsOfFile: book.image ?? "")
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        for image in images{
            if book.id == image.id{
                cell.bookImage.image = UIImage(data: image.image!)
            }
        }
        if rentCheck(id: book.id) {
            cell.rentImage.image = Constants.occupied
        }else {
            cell.rentImage.image = .none
        }
        
        return cell
    }
    
    
    func rentCheck(id: Int) -> Bool {
        if rents.contains(where: { $0.book_id == id }) {
            return true
        } 
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookID = books[indexPath.row].id
        delegate.showDetails(id: bookID)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 280)
    }
    
}
