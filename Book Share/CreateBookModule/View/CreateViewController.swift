//
//  CreateViewController.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import UIKit

class CreateViewController: UIViewController {
    
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var createView = CreateView()

    var createViewModel: CreateViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        setNavigationBar()
        createView.delegate = self
        setupViews()
      
    }
    
   
    
    private func setupViews(){
        [separatorView, createView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
       
        createView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
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
    func updateBook(book: CreateBook) {
        createViewModel.addBook(book: book)
        let mainVC = ModelBuilder.createMain()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
}

