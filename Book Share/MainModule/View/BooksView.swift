//
//  BooksView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import UIKit

protocol BooksViewProtocol {
    func getBooksID(id: Int)
    func moreBooks(books: [ViewData.Data])
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
//        tableView.allowsSelection = false
        return tableView
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
    
    var books = [String : [ViewData.Data]]()
    var keysArray = [String]()
    var delegate: BooksViewProtocol!
    
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
            activityIndicator.isHidden = false
        case .loading:
            tableView.isHidden = true
            activityIndicator.isHidden = false
        case .successWithGenres(let success):
            books = success
            keysArray = Array(books.keys)
            keysArray.sort()
            let element = keysArray.remove(at: 1)
            keysArray.insert(element, at: 0)
            tableView.isHidden = false
            activityIndicator.isHidden = true
            tableView.reloadData()
        case .success:
            activityIndicator.isHidden = true
            tableView.reloadData()
        case .failure:
            tableView.isHidden = false
            activityIndicator.isHidden = true
        }
    }
    
    private func setupViews(){
        [tableView, activityIndicator].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}


extension BooksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "books", for: indexPath) as! BookTableViewCell
        cell.backgroundColor = Constants.gray
        let key = keysArray[indexPath.row]
        cell.titleLabel.text = key
        cell.updateCV(books: books[key]!)
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
    func moreBooks(books: [ViewData.Data]) {
        delegate.moreBooks(books: books)
    }
    
    func showDetails(id: Int) {
        delegate.getBooksID(id: id)
    }
}
