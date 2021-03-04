//
//  ReservedBooksViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation

protocol ReservedBooksViewModelProtocol {
    var updateViewData: ((ReservedBooksViewData)->())? { get set }
    func startFetch()
}

final class ReservedBooksViewModel: ReservedBooksViewModelProtocol{
    var updateViewData: ((ReservedBooksViewData) -> ())?
    
    
    var books = [ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Lol", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Koko", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ReservedBooksViewData.Data(image: Constants.book!, title: "Koko", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic")]
    
    init() {
        updateViewData?(.initial)
    }
    
    func startFetch() {
        updateViewData?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let booksData = self?.books else { return }
            self?.updateViewData?(.success(booksData))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.updateViewData?(.failure)
    }
    
    
}
}
