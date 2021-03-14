//
//  MoreViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class MoreViewController: UIViewController {
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.logout, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.add, for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
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
    
    var moreView = MoreView()

    var moreViewModel: MoreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyles()
        moreViewModel.getRole()
        moreView.delegate = self
        moreViewModel.startFetch()
        updateView()
        setupViews()
    }

    private func updateView(){
        moreViewModel.updateViewData = { [weak self] viewData in
            self?.moreView.booksData = viewData
        }
        moreViewModel.updateRoles = { [weak self] viewData in
            self?.moreView.userRoles = viewData
        }
    }
    
    private func setStyles(){
        setNavigationBar()
        self.view.backgroundColor = Constants.gray
        moreView.backgroundColor = Constants.gray
    }
    
    @objc func logoutButtonPressed(){
        moreViewModel.logout()
        if let arrayOfTabBarItems = self.tabBarController!.tabBar.items as AnyObject as? NSArray {
            for i in 1..<arrayOfTabBarItems.count{
                let item = arrayOfTabBarItems[i] as? UITabBarItem
                item?.isEnabled = false
            }
        }
        logoutButton.isHidden = true
        addButton.isHidden = true
    }
    
    @objc func addButtonPressed() {
        let createVC = ModelBuilder.createCreateBook()
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    private func setupViews(){
        [addButton, logoutButton, separatorView, moreView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        logoutButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        moreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        moreView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moreView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: moreView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
    }
    
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        
         let backButton = UIBarButtonItem()
         backButton.title = "Back"
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
        navigationController?.navigationBar.tintColor = Constants.orange
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: logoutButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: addButton)]
    }
    
}
extension MoreViewController: MoreViewProtocol{
    func setErrorAlert(error: Error) {
        let alertViewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    func getRole(role: RolesViewData.Roles) {
        if role.role == "user"{
            addButton.isHidden = true
        }
    }
    
    func getBooksID(id: Int) {
        let detailsVC = ModelBuilder.createBookDetails(id: id)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
