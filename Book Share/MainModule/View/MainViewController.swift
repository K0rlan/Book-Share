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
    
    lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.notification, for: .normal)
        return button
    }()
    
    lazy var nightButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.moon, for: .normal)
        button.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        bookView.backgroundColor = Constants.gray
        bookView.delegateBooksViewProtocol = self
        setNavigationBar()
        viewModel.startFetch()
        updateView()
        setupViews()
        if Utils.isExpDate() {
            authViaGriffon()
        }
    }
    
    private func updateView(){
        viewModel.updateViewData = { [weak self] viewData in
            self?.bookView.booksData = viewData
        }
    }
    
    private func setupViews(){
        [appLabel, notificationButton, nightButton, separatorView, bookView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        appLabel.widthAnchor.constraint(equalToConstant: 164).isActive = true
        appLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        notificationButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        nightButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        nightButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        bookView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bookView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bookView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: bookView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
    }
    
    @objc func changeMode(_ sender: UIButton){
        
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appLabel)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: nightButton)]
    }
    
    func authViaGriffon(){
        let vc = SignInViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
}
extension MainViewController: BooksViewProtocol{
    func moreBooks(books: [ViewData.BooksData]) {
        if Griffon.shared.idToken != nil{
            let moreVC = ModelBuilder.createMoreBooks(books: books)
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
        let tab = TabBar()
        self.view.window?.rootViewController = tab
        self.view.window?.makeKeyAndVisible()
        viewModel.startFetch()
    }
    
    func successfullSignUp(_ ctrl: SignInViewController) {
        self.dismiss(animated: true)
        let tab = TabBar()
        self.view.window?.rootViewController = tab
        self.view.window?.makeKeyAndVisible()
        viewModel.startFetch()
    }
    
    
}
