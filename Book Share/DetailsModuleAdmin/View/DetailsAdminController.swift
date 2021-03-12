//
//  DetailsAdminController.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import UIKit

class DetailsAdminController: UIViewController {
    
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
    
    lazy var separatorViewForNavBar: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var detailsView = DetailsAdminView()
    
    var detailsViewModel: DetailsAdminViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        setNavigationBar()
        detailsViewModel.startFetch()
        setupViews()
        updateView()
    }
    
    private func updateView(){
        detailsViewModel.updateViewData = { [weak self] viewData in
            self?.detailsView.bookData = viewData
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
    
    private func setupViews(){
        [trashButton, editButton, separatorView, detailsView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        trashButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        trashButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: trashButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: editButton)]
    }
    

    
}

