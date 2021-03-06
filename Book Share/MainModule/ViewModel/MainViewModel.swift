//
//  MainViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Moya

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    let provider = MoyaProvider<APIService>()
    
    
    init() {
        updateViewData?(.initial)
    }
    
    func startFetch() {
        refreshTables()
        updateViewData?(.loading)
        fetchBooks()
        fetchGenres()
    }
    
    func fetchBooks(){
        provider.request(.getBooks) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let booksResponse = try JSONDecoder().decode([ViewData.BooksData].self, from: response.data)
//                    self?.updateViewData?(.successBooks(booksResponse))
                    self?.insertIntoDBBooks(books: booksResponse)
                } catch let error {
                    print("Error in parsing: \(error)")
                    self?.updateViewData?(.failure(error))
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                self?.updateViewData?(.failure(error))
            }
        }
    }
    
    func fetchGenres(){
        provider.request(.getGenres) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let genresResponse = try JSONDecoder().decode([ViewData.GenresData].self, from: response.data)
//                    self?.updateViewData?(.successGenres(genresResponse))
                    self?.insertIntoDBGenres(genres: genresResponse)
                } catch let error {
                    print("Error in parsing: \(error)")
                    self?.updateViewData?(.failure(error))
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                self?.updateViewData?(.failure(error))
            }
        }
    }
    
    func refreshTables(){
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM genres ")
                try db.execute(sql: "DELETE FROM books ")
            }
        } catch {
            print("\(error)")
        }
    }
    
    func insertIntoDBBooks(books: [ViewData.BooksData]){
        for book in books{
            do {
                try dbQueue.write { db in
                    var books = Books(
                        id: book.id,
                        isbn: book.isbn,
                        title: book.title,
                        author: book.author,
                        image: book.image,
                        publish_date: book.publish_date,
                        genre_id: book.genre_id
                    )
                    try! books.insert(db)
                }
            } catch {
                print("\(error)")
            }
        }
        do {
            try dbQueue.read { db in
                let draft = try Books.fetchAll(db)
                updateViewData?(.successBooks(draft))
                print("kokokoko\(draft)")
            }
        } catch {
            print("\(error)")
        }
       
    }
    
    func insertIntoDBGenres(genres: [ViewData.GenresData]){
        for genre in genres{
            do {
                try dbQueue.write { db in
                    var genres = Genres(
                        id: genre.id,
                        title: genre.title,
                        sort: genre.sort,
                        enabled: genre.enabled
                    )

                    try! genres.insert(db)
                }
            } catch {
                print("\(error)")
            }
        }
        
        do {
            try dbQueue.read { db in
                let draft = try Genres.fetchAll(db)
                updateViewData?(.successGenres(draft))
                print("kokokoko\(draft)")
            }
        } catch {
            print("\(error)")
        }
    }
    
}
