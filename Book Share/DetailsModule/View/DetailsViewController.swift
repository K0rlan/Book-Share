//
//  DetailsViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var trashButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.trash, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.send, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var separatorViewForNavBar: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var detailsView = DetailsView()
    var detailsViewModel: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        setNavigationBar()
        detailsViewModel.getRole()
        detailsViewModel.startFetch()
        detailsView.delegate = self
        setupViews()
        updateView()
    }
    
    private func updateView(){
        detailsViewModel.updateViewData = { [weak self] viewData in
            self?.detailsView.bookData = viewData
        }
        detailsViewModel.updateRoles = { [weak self] viewData in
            self?.detailsView.userRoles = viewData
        }
        detailsViewModel.updateComments = { [weak self] viewData in
            self?.detailsView.commentsData = viewData
        }
    }
    @objc func deleteButtonPressed(){
        detailsViewModel.deleteBook()
        let mainVC = ModelBuilder.createMain()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
    @objc func editButtonPressed(){
        let editVC = ModelBuilder.createEdit(id: detailsViewModel.getBookID())
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func sendButtonPressed(){
        detailsViewModel.adminSendPush()
    }
    
    private func setupViews(){
        [trashButton, editButton, sendButton, separatorView, detailsView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        trashButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        trashButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        sendButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        editButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: detailsView.bottomAnchor).isActive = true
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: trashButton),UIBarButtonItem(customView: editButton), UIBarButtonItem(customView: sendButton)]
    }
    
    
    
}
extension DetailsViewController: DetailsViewProtocol {
    
    func setErrorAlert(error: Error) {
        let alertViewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    func isBookNotAvailable(flag: Bool) {
        sendButton.alpha = 1
    }
    
    func deleteComment(id: Int) {
        detailsViewModel.deleteComment(id: id)
        detailsViewModel.getComments()
    }
    
    func updateComment(id: Int, text: String) {
        detailsViewModel.putComment(id: id, text: text)
        detailsViewModel.getComments()
    }
    
    func getRole(role: RolesViewData.Roles) {
        if role.role == "user"{
            print(role)
            trashButton.isHidden = true
            editButton.isHidden = true
            sendButton.isHidden = true
        }
    }
    
    func deleteRentButtonPressed() {
        detailsViewModel.deleteRent()
        let alert = UIAlertController(title: "Comment", message: "Leave a comment", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Enter title"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { [weak self] (alertAction) in
            let text = alert.textFields![0] as UITextField
            self?.detailsViewModel.addComment(text: text.text!)
            self?.view.window?.rootViewController = TabBar()
            self?.view.window?.makeKeyAndVisible()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func addRentButtonPressed() {
        detailsViewModel.addRent()
        self.view.window?.rootViewController = TabBar()
        self.view.window?.makeKeyAndVisible()
    }
    
    
}
