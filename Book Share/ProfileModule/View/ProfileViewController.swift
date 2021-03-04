//
//  ProfileViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
        return button
    }()
    
    lazy var separatorViewForNavBar: UIView = {
        let view = UIView()
        return view
    }()
    
    var profileView = ProfileView()
    
    private var profileViewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        profileViewModel.startFetch()
        setNavigationBar()
        updateView()
        setupViews()
    }
    
    private func setupViews(){
        [profileView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    private func updateView(){
        profileViewModel.updateViewData = { [weak self] profileData in
            self?.profileView.profileData = profileData
        }
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appLabel)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notificationButton), UIBarButtonItem(customView: separatorViewForNavBar),UIBarButtonItem(customView: nightButton)]
    }

}