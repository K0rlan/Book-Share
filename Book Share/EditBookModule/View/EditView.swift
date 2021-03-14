//
//  EditView.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import UIKit

protocol EditViewProtocol {
    func updateBook(book: EditBook)
    func getGenres(genres: [Genres])
    func showElements()
}

class EditView: UIView {
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Constants.gray?.cgColor
        textField.layer.cornerRadius = 8
        textField.placeholder = "Title"
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var isbnTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.placeholder = "ISBN"
        textField.layer.borderColor = Constants.gray?.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 50, width: self.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var authorTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.placeholder = "Author"
        textField.layer.borderColor = Constants.gray?.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
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
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    var delegate: EditViewProtocol!
    
    var genresData: GenresResponse = .initial{
        didSet{
            setNeedsLayout()
        }
    }
    
    var imagePath: String!
    var date: String!
    var genre: Int!
    var genres = [Genres]()
    
    var bookData: DetailsData = .initial{
            didSet{
                setNeedsLayout()
            }
        }
    
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setupViews()
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        date = dateFormatter.string(from: Date())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch genresData {
        case .success(let success):
            delegate.getGenres(genres: success)
            genres = success
        case .successImage(let success):
            imagePath = success
            editButton.isHidden = false
            self.activityIndicator.isHidden = true
        case .successGenre(let success):
            genre = success.id
        case .failure(let err):
            print(err)
        case .initial:
            print("")
        case .loading:
            print("")
        }
        
        switch bookData {
        case .initial:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .loading:
            self.isHidden = true
            activityIndicator.isHidden = false
        case .success(let success):
            self.isHidden = false
            self.update(viewData: success)
            delegate.showElements()
            activityIndicator.isHidden = true
        case .successImage(let success):
            self.isHidden = false
            activityIndicator.isHidden = true
        case .bookStatus:
            activityIndicator.isHidden = false
        case .failure:
            activityIndicator.isHidden = true
        }
    }
    private func update(viewData: DetailsData.Data?){
            guard let data = viewData  else { return }
            titleTextField.text = data.title
            authorTextField.text = data.author
            let dateFormatter = DateFormatter()
            
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from:data.publish_date)!
            datePicker.date = date
            isbnTextField.text = data.isbn
            
    }
    
   

    
    @objc func editButtonPressed(sender: UIButton) {
        guard let img = imagePath else {
            return
        }
        print(img)
        let book = EditBook(isbn: isbnTextField.text ?? "",
                              title: titleTextField.text ?? "",
                              author: authorTextField.text ?? "",
                              image: img,
                              publish_date: date ?? "",
                              genre_id: Int(genre ?? 4) ,
                              enabled: true )
        
        delegate.updateBook(book: book)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.date = selectedDate
    }
    
    public func newImage(){
        editButton.isHidden = true
        activityIndicator.isHidden = false
    }
    
    
    private func setupViews(){
        [titleTextField, isbnTextField, authorTextField, editButton, datePicker, activityIndicator].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        titleTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
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
        
        datePicker.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: 20).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        editButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        activityIndicator.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}
