//
//  MoreViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation

protocol MoreViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MoreViewModel: MoreViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    var books = [Books]()
    
    
    init() {
        updateViewData?(.initial)
    }
    
    init(books: [Books]) {
        updateViewData?(.initial)
        self.books = books
    }
    
    func startFetch() {
        updateViewData?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let booksData = self?.books else { return }
            self?.updateViewData?(.successBooks(booksData))
        }
        
    }
}
