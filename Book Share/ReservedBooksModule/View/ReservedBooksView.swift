//
//  ReservedBooksView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

class ReservedBooksView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.elements
        tableView.tintColor = .blue
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ReservedBooksTableViewCell.self, forCellReuseIdentifier: "reservedBooks")
        tableView.layer.cornerRadius = 14
        tableView.allowsSelection = false
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var reservedBooksData: ReservedBooksViewData = .initial{
        didSet{
            setNeedsLayout()
        }
    }
   
    var books: [ReservedBooksViewData.Data] = []
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch reservedBooksData {
        case .initial:
            tableView.isHidden = true
            activityIndicator.isHidden = false
        case .loading:
            tableView.isHidden = true
            activityIndicator.isHidden = false
        case .success(let success):
            tableView.isHidden = false
            activityIndicator.isHidden = true
            books = success
            print("asd\(success)")
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
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
}

extension ReservedBooksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservedBooks", for: indexPath) as! ReservedBooksTableViewCell
        let book = books[indexPath.row]
        print(books)
        cell.backgroundColor = Constants.elements
        cell.bookImage.image = book.image
        cell.titleLabel.text = book.title
        cell.genreLabel.text = book.genre
        cell.authorLabel.text = book.author
        cell.publishDateLabel.text = book.publishDate
        return cell
        
    }
}