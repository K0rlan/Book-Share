//
//  EditViewController.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import UIKit

class EditViewController: UIViewController {
    
    lazy var bookImage: UIButton = {
        let button = UIButton()
        button.setImage(Constants.photo, for: .normal)
        button.contentMode = .scaleToFill
        button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(bookImagePressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var editView = EditView()

    var editViewModel: EditViewModel!
    
    let pickerController = UIImagePickerController()
    var image: UIImage?
    var selectedGenre: String?
    let dropDown = UIPickerView()
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        editViewModel.startFetch()
        editViewModel.getGenres()
        dropDown.isHidden = true
        pickerController.delegate = self
        dropDown.dataSource = self
        dropDown.delegate = self
        setNavigationBar()
        editView.delegate = self
        setupViews()
        updateView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func updateView(){
        editViewModel.updateViewData = { [weak self] viewData in
            self?.editView.genresData = viewData
        }
        
        editViewModel.updateEditData = { [weak self] viewData in
                self?.editView.bookData = viewData
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
        [separatorView, editView, bookImage, dropDown].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bookImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bookImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        bookImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dropDown.topAnchor.constraint(equalTo: bookImage.bottomAnchor).isActive = true
        dropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dropDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        dropDown.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        editView.topAnchor.constraint(equalTo: dropDown.bottomAnchor).isActive = true
        editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        editView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        separatorView.topAnchor.constraint(equalTo: editView.bottomAnchor).isActive = true
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
extension EditViewController: EditViewProtocol {
    func showElements() {
        bookImage.isHidden = false
        dropDown.isHidden = false
    }
    
    
    
    func getGenres(genres: [Genres]) {
        for index in 1..<genres.count{
            list.append(genres[index].title)
        }
        dropDown.reloadAllComponents()
    }
    
    func updateBook(book: EditBook) {
        editViewModel.putBook(book: book)
        let mainVC = ModelBuilder.createMain()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
}

extension EditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
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
            editView.newImage()
            bookImage.setImage(theImage, for: .normal)
            editViewModel.uploadImage(image: theImage)
            self.image = theImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
           return 1
       }

       public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

           return list.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedGenre = self.list[0]
        self.view.endEditing(true)
           return list[row] ?? list[0]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.selectedGenre = self.list[row]
        editViewModel.getGenre(name: selectedGenre ?? list[1])
      
       }

}

