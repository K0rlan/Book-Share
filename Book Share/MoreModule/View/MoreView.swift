//
//  MoreView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

protocol MoreViewProtocol {
    func getBooksID(id: Int)
}

class MoreView: UIView{
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = Constants.gray
        searchBar.placeholder = "Search..."
        searchBar.barTintColor = Constants.gray
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = Constants.orange
        searchBar.searchTextField.leftView?.tintColor = Constants.dark
        searchBar.searchTextField.backgroundColor = Constants.elements
        searchBar.delegate = self
        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.gray
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MoreTableViewCell.self, forCellReuseIdentifier: "books")
        tableView.layer.cornerRadius = 14
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var booksData: MoreModel = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var filteredData: [Books] = []
    var books: [Books] = []
    var images = [BooksImages]()
    var delegate: MoreViewProtocol!
    
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
        case .successBooks(let success):
            books = success
            filteredData = books
            tableView.reloadData()
        case .successImage(let success):
            tableView.isHidden = false
            activityIndicator.isHidden = true
            images = success
            tableView.reloadData()
        case .failure:
            tableView.isHidden = false
            activityIndicator.isHidden = true
        case .successRent(let success):
            print(success)
        }
    }
    
    private func setupViews(){
        [searchBar, tableView, activityIndicator].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 20).isActive = true
        searchBar.searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor,constant: -20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}

extension MoreView: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? books : books.filter({(books: Books) -> Bool in
            return books.title.range(of: searchText, options: .caseInsensitive) != nil || books.author.range(of: searchText, options: .caseInsensitive) != nil
        })
       
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
}

extension MoreView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "books", for: indexPath) as! MoreTableViewCell
        let book = filteredData[indexPath.row]
        cell.backgroundColor = Constants.gray
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.publishDateLabel.text = book.publish_date
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        cell.bookImage.image = .none
        for image in images{
            if book.id == image.id{
                cell.bookImage.image = UIImage(data: image.image!)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookID = filteredData[indexPath.row].id
        delegate.getBooksID(id: bookID)
    }
    
}
