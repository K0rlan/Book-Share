//
//  BooksView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import UIKit

protocol BooksViewProtocol {
    func getBooksID(id: Int)
    func moreBooks(id: Int)
}

class BooksView: UIView{
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.gray
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "books")
        tableView.layer.cornerRadius = 14
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
//        flowLayout.estimatedItemSize = CGSize(width: 120, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = Constants.gray
        return collectionView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var booksData: ViewData = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var books = [Books]()
    var genres = [Genres]()
    var keysArray = [String]()
    var delegateBooksViewProtocol: BooksViewProtocol!
    var images = [ViewData.BooksImages]()
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setupViews()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch booksData {
        case .initial:
            tableView.isHidden = true
            collectionView.isHidden = true
            activityIndicator.isHidden = false
        case .loading:
            tableView.isHidden = true
            collectionView.isHidden = true
            activityIndicator.isHidden = false
        case .successGenres(let success):
            genres = success
            collectionView.reloadData()
            tableView.reloadData()
        case .successBooks(let success):
            books = success
            tableView.reloadData()
        case .successImage(let success):
            images.append(success)
            tableView.reloadData()
            collectionView.isHidden = false
            tableView.isHidden = false
            activityIndicator.isHidden = true
        case .failure:
            tableView.isHidden = false
            collectionView.isHidden = false
            activityIndicator.isHidden = true
        }
    }
    
    private func setupViews(){
        [tableView, activityIndicator, collectionView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}


extension BooksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "books", for: indexPath) as! BookTableViewCell
        cell.backgroundColor = Constants.gray
        let genreID = genres[indexPath.row].id
        var filteresArray = books.filter { $0.genre_id == genreID }
        if genreID == 0 {
            filteresArray.append(contentsOf: books)
        }
        cell.titleLabel.text = genres[indexPath.row].title 
        cell.updateCV(books: filteresArray, id: genres[indexPath.row].id, images: images)
        cell.contentView.isUserInteractionEnabled = false
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        320
    }
}
extension BooksView: BookTableViewCellDelegate{
    func moreBooks(id: Int) {
        delegateBooksViewProtocol.moreBooks(id: id)
    }
    
    func showDetails(id: Int) {
        delegateBooksViewProtocol.getBooksID(id: id)
    }
}
extension BooksView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCollectionViewCell
        cell.setText(text: genres[indexPath.row].title)
//        if indexPath.row == 0 {
//            cell.isSelected = true
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = genres[indexPath.item].title
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = NSIndexPath(row: indexPath.row, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
//        let koko = NSIndexPath(row: 0, section: 0)
//        if let cell = collectionView.cellForItem(at: koko as IndexPath)  {
//            cell.isSelected = false
//        }
    }
    
    

}
