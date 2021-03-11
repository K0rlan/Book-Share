//
//  ModelBuilder.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import Foundation
import UIKit

protocol Builder {
    static func createMain() -> UIViewController
    static func createProfile() -> UIViewController
    static func createReservedBooks() -> UIViewController
    static func createBookDetails(id: Int) -> UIViewController
    static func createMoreBooks(id: Int) -> UIViewController
    static func createSearch() -> UIViewController
}


class ModelBuilder: Builder {
    static func createSearch() -> UIViewController {
        let view = SearchByCodeController()
        return view
    }
    
    
    static func createMain() -> UIViewController {
        let view = MainViewController()
        return view
    }
    static func createProfile() -> UIViewController {
        let view = ProfileViewController()
        return view
    }
    
    static func createReservedBooks() -> UIViewController {
        let view = ReservedBooksViewController()
        return view
    }
    
    static func createBookDetails(id: Int) -> UIViewController {
        let view = DetailsViewController()
        let viewModel = DetailsViewModel(bookID: id)
        view.detailsViewModel = viewModel
        return view
    }
    
    static func createBookDetailsAdmin(id: Int) -> UIViewController {
        let view = DetailsAdminController()
        let viewModel = DetailsAdminViewModel(bookID: id)
        view.detailsViewModel = viewModel
        return view
    }
    
    static func createEdit(id: Int) -> UIViewController {
        let view = EditViewController()
        let viewModel = EditViewModel(bookID: id)
        view.editViewModel = viewModel
        return view
    }
    static func createCreateBook() -> UIViewController {
        let view = CreateViewController()
        let viewModel = CreateViewModel()
        view.createViewModel = viewModel
        return view
    }


    static func createMoreBooks(id: Int) -> UIViewController {
        let view = MoreViewController()
        let viewModel = MoreViewModel(id: id)
        view.moreViewModel = viewModel
        return view
    }
}
