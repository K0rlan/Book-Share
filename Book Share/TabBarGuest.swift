//
//  TabBarGuest.swift
//  Book Share
//
//  Created by Korlan Omarova on 04.03.2021.
//

import Foundation
import UIKit

class TabBarGuest: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupVCs()
        setStyles()
    }
  
    public func setStyles(){
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 50, y: self.tabBar.bounds.minY - 15, width: self.tabBar.bounds.width - 100, height: self.tabBar.bounds.height + 10), cornerRadius: 14).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.8
        layer.borderWidth = 1

        layer.masksToBounds = false
        layer.fillColor = Constants.elements?.cgColor
        
        
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()

        self.tabBar.layer.insertSublayer(layer, at: 0)
        self.tabBar.itemSpacing = UIScreen.main.bounds.width / 2
        if let items = self.tabBar.items {
          items.forEach {
            item in item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0) }
        }
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = tabBar.bounds.width / 50
        
        tabBar.tintColor = Constants.orange
//        tabBar.barTintColor = .blue
       
        
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: ModelBuilder.createMain(), title: NSLocalizedString("", comment: ""), image: Constants.home!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isHidden = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
    
}
