//
//  MainViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import UIKit
import Griffon_ios_spm

class MainViewController: UIViewController {
    
    lazy var appLabel: UILabel = {
        let label = UILabel()
        label.text = "Dar Library"
        label.textColor = Constants.dark
        label.font = .boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.logout, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        //        button.isHidden = true
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
    
    
    lazy var bookView = BooksView()
    private var viewModel = MainViewModel()
    
    var bookID = 0
    
    var userRole: RolesViewData.Roles!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startFetch()
//        viewModel.fetchRents()
        self.view.backgroundColor = Constants.gray
        bookView.backgroundColor = Constants.gray
        bookView.delegateBooksViewProtocol = self
        setNavigationBar()
        updateView()
        setupViews()
        if Utils.isExpDate() {
            authViaGriffon()
        }
        if Utils.getUserID() == ""{
            if let arrayOfTabBarItems = self.tabBarController!.tabBar.items as AnyObject as? NSArray {
                for i in 1..<arrayOfTabBarItems.count{
                    let item = arrayOfTabBarItems[i] as? UITabBarItem
                    item?.isEnabled = false
                }
                logoutButton.isHidden = true
                addButton.isHidden = true
            }
        }
    }
    
    private func updateView(){
        viewModel.updateViewData = { [weak self] viewData in
            self?.bookView.booksData = viewData
        }
        viewModel.updateImages = { [weak self] viewData in
            self?.bookView.bookImage = viewData
        }
        viewModel.updateRoles = { [weak self] viewData in
            self?.bookView.userRoles = viewData
        }
        
        viewModel.updateRent = { [weak self] viewData in
            self?.bookView.bookRent = viewData
        }
    }
    
    private func setupViews(){
        [appLabel, logoutButton, addButton, separatorView, bookView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        appLabel.widthAnchor.constraint(equalToConstant: 164).isActive = true
        appLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        logoutButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        addButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        bookView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bookView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bookView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: bookView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
    }
    
    @objc func logoutButtonPressed(){
        viewModel.logout()
        if let arrayOfTabBarItems = self.tabBarController!.tabBar.items as AnyObject as? NSArray {
            for i in 1..<arrayOfTabBarItems.count{
                let item = arrayOfTabBarItems[i] as? UITabBarItem
                item?.isEnabled = false
            }
        }
    }
    
    @objc func addButtonPressed() {
        let createVC = ModelBuilder.createCreateBook()
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc func requestButtonPressed() {
        let alert = UIAlertController(title: "Request for new book", message: "Enter title and author of book that you want to add", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Enter title"
        }
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Enter author"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { [weak self] (alertAction) in
            let title = alert.textFields![0] as UITextField
            let author = alert.textFields![1] as UITextField
            self?.viewModel.requestForBook(title: title.text!, author: author.text!)
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appLabel)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: logoutButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: addButton)]
    }
    
    func authViaGriffon(){
        let vc = SignInViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
}
extension MainViewController: BooksViewProtocol{
    func getRole(role: RolesViewData.Roles) {
        if role.role == "user"{
            addButton.isHidden = true
        }else {
            addButton.isHidden = false

        }
    }
    
    func moreBooks(id: Int) {
        if Griffon.shared.idToken != nil{
            let moreVC = ModelBuilder.createMoreBooks(id: id)
            self.navigationController?.pushViewController(moreVC, animated: true)
        }else {
            authViaGriffon()
        }
    }
    
    func getBooksID(id: Int) {
        self.bookID = id
        if Griffon.shared.idToken != nil{
            let detailsVC = ModelBuilder.createBookDetails(id: bookID)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }else {
            authViaGriffon()
        }
        
    }
}
extension MainViewController: SignInViewControllerDelegate {
    func successfullSignIn(_ ctrl: SignInViewController) {
        self.dismiss(animated: true)
        if let arrayOfTabBarItems = self.tabBarController!.tabBar.items as AnyObject as? NSArray {
            for i in 1..<arrayOfTabBarItems.count{
                let item = arrayOfTabBarItems[i] as? UITabBarItem
                item?.isEnabled = true
            }
        }
        logoutButton.isHidden = false
        addButton.isHidden = false
        viewModel.getRole()
        viewModel.getExpiredBooks()
        viewModel.saveUserToken()
    }
    
    func successfullSignUp(_ ctrl: SignInViewController) {
        self.dismiss(animated: true)
        viewModel.saveUserToken()
        if let arrayOfTabBarItems = self.tabBarController!.tabBar.items as AnyObject as? NSArray {
            for i in 1..<arrayOfTabBarItems.count{
                let item = arrayOfTabBarItems[i] as? UITabBarItem
                item?.isEnabled = true
            }
        }
        logoutButton.isHidden = false
        addButton.isHidden = false
        viewModel.setRole()
        viewModel.saveUserToken()
    }
}

