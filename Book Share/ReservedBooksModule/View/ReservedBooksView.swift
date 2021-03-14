//
//  ReservedBooksView.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

protocol ReservedBooksViewProtocol {
    func setErrorAlert(error: Error)
    func getBooksID(id: Int)
}


class ReservedBooksView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tintColor = .blue
        tableView.register(ReservedBooksTableViewCell.self, forCellReuseIdentifier: "reservedBooks")
        tableView.layer.cornerRadius = 14
        tableView.backgroundColor = Constants.gray
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    lazy var defaultLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose books"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.isHidden = true
        return label
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
    
    var books: [ReservedBooksViewData.RentsData] = []
    var images = [BooksImages]()
    
    var delegate: ReservedBooksViewProtocol!
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        tableView.reloadData()
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
            if books.isEmpty {
                tableView.isHidden = true
                defaultLabel.isHidden = false
            }
            tableView.reloadData()
        case .successImage(let success):
            images = success
            tableView.reloadData()
        case .failure(let error):
            tableView.isHidden = false
            activityIndicator.isHidden = true
            delegate.setErrorAlert(error: error)
        }
           
    }
    
    private func setupViews(){
        [tableView, activityIndicator, defaultLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        defaultLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        defaultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
}

extension ReservedBooksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservedBooks", for: indexPath) as! ReservedBooksTableViewCell
        let book = books[indexPath.row].book
        cell.backgroundColor = Constants.elements
        for image in images {
            if book?.id == image.id {
                cell.bookImage.image = UIImage(data: image.image!)
            }
        }
        cell.backgroundColor = Constants.gray
        cell.titleLabel.text = book?.title
        cell.authorLabel.text = book?.author
        cell.publishDateLabel.text = book?.publish_date
        cell.isbnLabel.text = book?.isbn
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookID = books[indexPath.row].book!.id
        delegate.getBooksID(id: bookID)
    }
}
