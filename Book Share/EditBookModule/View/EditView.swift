//
//  EditView.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import UIKit

protocol EditViewProtocol {
    func updateBook(book: EditBook)
}

class EditView: UIView {
    
    lazy var bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var isbnTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var authorTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var publishDateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var genreIdTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var enabledTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
        return textField
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.orange
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.borderColor = Constants.orange.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 4)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.1
        button.setTitle("Update", for: .normal)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var bookData: DetailsData = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var delegate: EditViewProtocol!
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setStyles()
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editButtonPressed(sender: UIButton) {
        let book = EditBook(isbn: isbnTextField.text ?? "",
                            title: titleTextField.text ?? "",
                            author: authorTextField.text ?? "",
                            publish_date: publishDateTextField.text ?? "",
                            genre_id: Int(genreIdTextField.text!) ,
                            enabled: Bool(enabledTextField.text!) )
        delegate.updateBook(book: book)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch bookData {
        case .initial:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .loading:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .success(let success):
            self.isHidden = true
            self.update(viewData: success)
            activityIndicator.isHidden = true
        case .successImage(let success):
            self.updateImage(image: success)
            self.isHidden = false
            activityIndicator.isHidden = true
        case .bookStatus:
            activityIndicator.isHidden = false
        case .failure:
            activityIndicator.isHidden = true
        }
    }
    
    private func setStyles(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: -4)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.1
    }
    
    private func update(viewData: DetailsData.Data?){
        guard let data = viewData  else { return }
        titleTextField.text = data.title
        authorTextField.text = data.author
        publishDateTextField.text = data.publish_date
        isbnTextField.text = data.isbn
        genreIdTextField.text = String(data.genre_id!)
        enabledTextField.text = String(data.enabled)
        
    }
    private func updateImage(image: UIImage){
        bookImage.image = image
        bookImage.alpha = 1
    }
    
    
    private func setupViews(){
        [bookImage, titleTextField, isbnTextField, authorTextField, publishDateTextField, genreIdTextField, enabledTextField, editButton, activityIndicator].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.widthAnchor.constraint(equalToConstant: 105).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        bookImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        titleTextField.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        isbnTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        isbnTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        isbnTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        isbnTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        authorTextField.topAnchor.constraint(equalTo: isbnTextField.bottomAnchor, constant: 20).isActive = true
        authorTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        authorTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        authorTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        publishDateTextField.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: 20).isActive = true
        publishDateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        publishDateTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        publishDateTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        genreIdTextField.topAnchor.constraint(equalTo: publishDateTextField.bottomAnchor, constant: 20).isActive = true
        genreIdTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        genreIdTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        genreIdTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        enabledTextField.topAnchor.constraint(equalTo: genreIdTextField.bottomAnchor, constant: 20).isActive = true
        enabledTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        enabledTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        enabledTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        editButton.topAnchor.constraint(equalTo: enabledTextField.bottomAnchor, constant: 20).isActive = true
        editButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
      
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}
