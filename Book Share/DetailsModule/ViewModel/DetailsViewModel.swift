//
//  DetailsViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation

protocol DetailsViewModelProtocol {
    var updateViewData: ((DetailsData)->())? { get set }
    func startFetch()
}

class DetailsViewModel: DetailsViewModelProtocol{
    var updateViewData: ((DetailsData) -> ())?
    let bookID: Int
//    let book: DetailsData!
    
//    var books = DetailsData.Data(id: 2, isbn: "1223423", image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3)
    
    var books = [DetailsData.Data(id: 2, isbn: "1223423", image: Constants.book!, title: "Fantasy", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 3, isbn: "1223423", image: Constants.book!, title: "Lol", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 4, isbn: "1223423",  image: Constants.book!, title: "Fantasy", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 5,  isbn: "1223423", image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 6, isbn: "1223423",  image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 7,  isbn: "1223423", image: Constants.book!, title: "Koko", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 8, isbn: "1223423",  image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 9, isbn: "2345234", image: Constants.book!, title: "Fantasy", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3), DetailsData.Data(id: 10, isbn: "1223423",  image: Constants.book!, title: "Koko", author: "Jane Austin", publish_date: "23.22.1923", genre_id: 3)]
    
    init(bookID: Int) {
        updateViewData?(.initial)
        self.bookID = bookID
    }
    
    func startFetch() {
        var book: DetailsData.Data!
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            
            self?.books.forEach {
                if $0.id == self?.bookID{
                    book = $0
                }
            }
            self?.updateViewData?(.success(book))
        })
        
    }
}
