//
//  MainViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?


    var books = [ ViewData.Data(id: 2, image: Constants.book!, title: "Fantasy", author: "Jane Austin", publishDate: "23.22.1923", genre: "Fantasy"), ViewData.Data(id: 3, image: Constants.book!, title: "Lol", author: "Jane Austin", publishDate: "23.22.1923", genre: "Scince Fiction"), ViewData.Data(id: 4, image: Constants.book!, title: "Fantasy", author: "Jane Austin", publishDate: "23.22.1923", genre: "Fantasy"), ViewData.Data(id: 5, image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ViewData.Data(id: 6, image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Adventure"), ViewData.Data(id: 7, image: Constants.book!, title: "Koko", author: "Jane Austin", publishDate: "23.22.1923", genre: "Scince Fiction"), ViewData.Data(id: 8, image: Constants.book!, title: "Pride and Prejudice", author: "Jane Austin", publishDate: "23.22.1923", genre: "Classic"), ViewData.Data(id: 9, image: Constants.book!, title: "Fantasy", author: "Jane Austin", publishDate: "23.22.1923", genre: "Fantasy"), ViewData.Data(id: 10, image: Constants.book!, title: "Koko", author: "Jane Austin", publishDate: "23.22.1923", genre: "Scince Fiction")]


    var genres = ["Classic", "Scince Fiction", "Fantasy", "Adventure"]

    var filteredByGenre = [String : [ViewData.Data]]()

    init() {
        updateViewData?(.initial)
    }

    func startFetch() {
        updateViewData?(.loading)
        var filteredArr = [ViewData.Data]()
        for i in genres{
            filteredArr = books.filter { $0.genre == i }
            filteredByGenre[i] = filteredArr
        }
        filteredByGenre["All Books"] = books
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let booksData = self?.filteredByGenre else { return }
            self?.updateViewData?(.successWithGenres(booksData))
        }
        print(filteredByGenre)


    }
}
