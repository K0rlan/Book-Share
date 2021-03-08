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
    var updateImages: ((ViewImages)->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    var updateImages: ((ViewImages)->())?
    let provider = MoyaProvider<APIService>()
    var images = [ViewImages.BooksImages]()
    
    let provide = MoyaProvider<APIImage>()
    init() {
        updateViewData?(.initial)
        updateImages?(.initial)
    }
    
    func startFetch() {
        updateViewData?(.loading)
        updateImages?(.loading)
        refreshTables()
        fetchBooks()
        fetchRents()
        fetchGenres()
    }
    
    func fetchBooks(){
        provider.request(.getBooks) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let booksResponse = try JSONDecoder().decode([ViewData.BooksData].self, from: response.data)
                    self?.fetchImages(books: booksResponse)
                    self?.insertIntoDBBooks(books: booksResponse)
                    self?.updateViewData?(.successBooks(booksResponse))
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
                            let book = ViewImages.BooksImages(id: book.id, image: img)
                            self?.images.append(book)
                            self?.updateImages?(.successImage(self!.images))
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
    func fetchRents(){
        provider.request(.getRent) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let rentsResponse = try JSONDecoder().decode([ViewData.RentsData].self, from: response.data)
                    self?.updateViewData?(.successRent(rentsResponse))
                    self?.insertIntoDBRents(rents: rentsResponse)
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
                try db.execute(sql: "DELETE FROM genres")
                try db.execute(sql: "DELETE FROM books")
                try db.execute(sql: "DELETE FROM booking")
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
        
    }
    
    func insertIntoDBRents(rents: [ViewData.RentsData]){
        for rent in rents{
            
            do {
                try dbQueue.write { db in
                    var rents = Booking(
                        id: rent.id,
                        user_id: rent.user_id,
                        book_id: rent.book_id,
                        start_date: rent.start_date,
                        end_date: rent.end_date
                    )
                    try! rents.insert(db)
                }
            } catch {
                print("\(error)")
            }
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
        DispatchQueue.main.async { [weak self] in
            do {
                try dbQueue.read { db in
                    let draft = try Genres.fetchAll(db)
                    self?.updateViewData?(.successGenres(draft))
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
}
