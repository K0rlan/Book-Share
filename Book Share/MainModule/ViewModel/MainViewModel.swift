//
//  MainViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Moya
import UIKit

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    let provider = MoyaProvider<APIService>()
    
    var images = [ViewData.BooksImages]()
    
    let provide = MoyaProvider<APIImage>()
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
                    self?.insertIntoDBBooks(books: booksResponse)
                    self?.fetchImages(books: booksResponse)
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
    
    func fetchImages(books: [ViewData.BooksData]){
        for book in books{
            if let img = book.image{
                provide.request(.getImage(imageName: img)) { [weak self] (result) in
                    switch result{
                    case .success(let response):
                        do {
                            let img = try response.mapImage().jpegData(compressionQuality: 1)
                            let book = ViewData.BooksImages(id: book.id, image: img)
                            self?.updateViewData?(.successImage(book))
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
        }
    }
    
    func refreshTables(){
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM genres ")
                try db.execute(sql: "DELETE FROM books ")
                try db.execute(sql: "DELETE FROM booksImages ")
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
            }
        } catch {
            print("\(error)")
        }
        
        
    }
    
    
    
    
    func insertIntoDBAll(){
        do {
            try dbQueue.write { db in
                var genres = Genres(
                    id: 0,
                    title: "All Books",
                    sort: 0,
                    enabled: false
                )
                try! genres.insert(db)
            }
        } catch {
            print("\(error)")
        }
    }
    
    func insertIntoDBGenres(genres: [ViewData.GenresData]){
        insertIntoDBAll()
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
            }
        } catch {
            print("\(error)")
        }
    }
    
}
