//
//  CreateViewController.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import UIKit

class CreateViewController: UIViewController {
    
    lazy var bookImage: UIButton = {
        let button = UIButton()
        button.setImage(Constants.book, for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(bookImagePressed), for: .touchUpInside)
        return button
    }()
    
//    lazy var textBox: UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.layer.borderWidth = 1
//        textField.placeholder = "Genre ID"
//        textField.layer.borderColor = CGColor(red: 220/255, green: 220/255, blue: 222/255, alpha: 1)
//        textField.layer.cornerRadius = 8
//        textField.backgroundColor = UIColor(cgColor: CGColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1))
//        return textField
//    }()
    
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var createView = CreateView()

    var createViewModel: CreateViewModel!
    
    let pickerController = UIImagePickerController()
    var image: UIImage?
    var selectedGenre: String?
    let dropDown = UIPickerView()
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        pickerController.delegate = self
        createViewModel.getGenres()
        dropDown.dataSource = self
        dropDown.delegate = self
        setNavigationBar()
        createView.delegate = self
        setupViews()
        updateView()
      
    }
    
    private func updateView(){
        createViewModel.updateViewData = { [weak self] viewData in
            self?.createView.genresData = viewData
        }
        
    }
    
    
    @objc func bookImagePressed(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.takePhotoWithCamera() })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Загрузить из галереи", style: .default, handler: { _ in self.choosePhotoFromLibrary() })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    private func setupViews(){
        [separatorView, createView, bookImage, dropDown].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        bookImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bookImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
//        textBox.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20).isActive = true
//        textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        dropDown.topAnchor.constraint(equalTo: bookImage.bottomAnchor).isActive = true
        dropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dropDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        createView.topAnchor.constraint(equalTo: dropDown.bottomAnchor).isActive = true
        createView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        createView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        separatorView.topAnchor.constraint(equalTo: createView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationController?.navigationBar.tintColor = Constants.orange
        
    }
    

    
}
extension CreateViewController: CreateViewProtocol {
    func getGenres(genres: [Genres]) {
        for index in 1..<genres.count{
            list.append(genres[index].title)
        }
        dropDown.reloadAllComponents()
    }
    
    func updateBook(book: CreateBook) {
        createViewModel.addBook(book: book)
        let mainVC = ModelBuilder.createMain()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
}

extension CreateViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func choosePhotoFromLibrary() {
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            pickerController.sourceType = .camera
            pickerController.allowsEditing = true
            present(pickerController, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Ошибка", message: "Нету камеры", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            bookImage.setImage(theImage, for: .normal)
            createViewModel.uploadImage(image: theImage)
            self.image = theImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
           return 1
       }

       public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

           return list.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedGenre = self.list[0]
        print(selectedGenre)
        self.view.endEditing(true)
           return list[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

//           self.textBox.text = self.list[row]
//           self.dropDown.isHidden = true
        self.selectedGenre = self.list[row]
        createViewModel.getGenre(name: selectedGenre!)
        print(selectedGenre)
       }

//       func textFieldDidBeginEditing(_ textField: UITextField) {
//
//           if textField == self.textBox {
//               self.dropDown.isHidden = false
//               //if you don't want the users to se the keyboard type:
//
//               textField.endEditing(true)
//           }
//       }
}
