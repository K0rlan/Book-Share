//
//  MoreViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import UIKit

class MoreViewController: UIViewController {
    
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
    
    
    var moreView = MoreView()

    var moreViewModel = MoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        moreView.backgroundColor = Constants.gray
        moreView.delegate = self
        setNavigationBar()
        moreViewModel.startFetch()
        updateView()
        setupViews()
//        if UserDefaults.standard.bool(forKey: "nightMode"){
//            overrideUserInterfaceStyle = .light
//        }else{
//            overrideUserInterfaceStyle = .dark
//        }
        
    }

    private func updateView(){
        moreViewModel.updateViewData = { [weak self] viewData in
            self?.moreView.booksData = viewData
        }
    }
    
    private func setupViews(){
        [notificationButton, nightButton, separatorView, moreView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        notificationButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        nightButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        nightButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        moreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        moreView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moreView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: moreView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
    }
    
    @objc func changeMode(_ sender: UIButton){
        if UserDefaults.standard.bool(forKey: "nightMode"){
        UserDefaults.standard.setValue(false, forKey: "nightMode")
            print(UserDefaults.standard.bool(forKey: "nightMode"))
            overrideUserInterfaceStyle = .light
        
        }else{
            UserDefaults.standard.setValue(true, forKey: "nightMode")
            print(UserDefaults.standard.bool(forKey: "nightMode"))
            overrideUserInterfaceStyle = .dark
            
        }
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: nightButton)]
    }
    
}
extension MoreViewController: MoreViewProtocol{
    func getBooksID(id: Int) {
        let detailsVC = ModelBuilder.createBookDetails(id: id)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
