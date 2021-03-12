//
//  ReservedBooksViewController.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import UIKit
import Griffon_ios_spm
class ReservedBooksViewController: UIViewController {
    lazy var appLabel: UILabel = {
        let label = UILabel()
        label.text = "Dar Library"
        label.textColor = Constants.dark
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var separatorViewForNavBar: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    var reservedBooksView = ReservedBooksView()
    
    private var reservedBooksViewModel = ReservedBooksViewModel()
    
    var userRole: RolesViewData.Roles!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.gray
        setNavigationBar()
        reservedBooksViewModel.startFetch()
        updateView()
        setupViews()

        if Utils.isExpDate(){
            authViaGriffon()
        }
    }
    
    private func authViaGriffon(){
        let vc = SignInViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func updateView(){
        reservedBooksViewModel.updateViewData = { [weak self] reservedBooksData in
            self?.reservedBooksView.reservedBooksData = reservedBooksData
        }
       
    }
    
    private func setupViews(){
        [appLabel, separatorView, reservedBooksView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        appLabel.widthAnchor.constraint(equalToConstant: 164).isActive = true
        appLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        separatorViewForNavBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        separatorViewForNavBar.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        reservedBooksView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        reservedBooksView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reservedBooksView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: reservedBooksView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
    }
    private func setNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = Constants.gray
        navigationController?.navigationBar.barTintColor = .orange
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appLabel)
        
    }

    

}
extension ReservedBooksViewController: SignInViewControllerDelegate {
    func successfullSignIn(_ ctrl: SignInViewController) {
        self.dismiss(animated: true)
    }
    
    func successfullSignUp(_ ctrl: SignInViewController) {
        self.dismiss(animated: true)
    }
}
