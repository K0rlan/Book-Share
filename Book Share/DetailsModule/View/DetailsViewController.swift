//
//  DetailsViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.notification, for: .normal)
        return button
    }()
    
    lazy var nightButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.moon, for: .normal)
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
        detailsViewModel.startFetch()
        detailsView.delegate = self
        setupViews()
        updateView()
    }
    
    private func updateView(){
        detailsViewModel.updateViewData = { [weak self] viewData in
            self?.detailsView.bookData = viewData
        }
    }
    
    private func setupViews(){
        [notificationButton, nightButton, separatorView, detailsView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        notificationButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        nightButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        nightButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: nightButton)]
    }
    
    
    
}
extension DetailsViewController: DetailsViewProtocol {
    func deleteRentButtonPressed() {
        detailsViewModel.deleteRent()
    }
    
    func addRentButtonPressed() {
        detailsViewModel.addRent()
    }
    
    
}
