//
//  EditViewController.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import UIKit

class EditViewController: UIViewController {
    
    lazy var trashButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.trash, for: .normal)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.edit, for: .normal)
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

    lazy var editView = EditView()

    var editViewModel: EditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        setNavigationBar()
        editViewModel.startFetch()
        editView.delegate = self
        setupViews()
        updateView()
    }
    
    private func updateView(){
        editViewModel.updateViewData = { [weak self] viewData in
            self?.editView.bookData = viewData
        }
    }
    
    private func setupViews(){
        [trashButton, editButton, separatorView, editView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        trashButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        trashButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        editButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        editView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: trashButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: editButton)]
    }
    

    
}
extension EditViewController: EditViewProtocol {
    func updateBook(book: EditBook) {
        editViewModel.putBook(book: book)
        let mainVC = ModelBuilder.createMain()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
}
