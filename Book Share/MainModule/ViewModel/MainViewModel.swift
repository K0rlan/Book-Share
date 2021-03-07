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
    
    var arrImages = [Int : UIImage]()
    
    let provide = MoyaProvider<APIImage>()
    init() {
        updateViewData?(.initial)
    }
    
    func startFetch() {
        refreshTables()
        updateViewData?(.loading)
        fetchBooks()
        fetchGenres()
//        fetchRent()
    }
    
    func fetchBooks(){
        provider.request(.getBooks) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let booksResponse = try JSONDecoder().decode([ViewData.BooksData].self, from: response.data)
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
    
//    func fetchImage(image: String, id: Int){
//        provide.request(.getImage(imageName: image)) { [weak self] (result) in
//            switch result{
//            case .success(let response):
//                do {
//                    let response = try response.mapImage()
//
////                    self?.updateViewData?(.successImage(response))
//                } catch let error {
//                    print("Error in parsing: \(error)")
//                    self?.updateViewData?(.failure(error))
//                }
//            case .failure(let error):
//                let requestError = (error as NSError)
//                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
//                self?.updateViewData?(.failure(error))
//            }
//        }
//    }
    
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
    
//    func fetchRent(){
//        provider.request(.getRent) { [weak self] (result) in
//            switch result{
//            case .success(let response):
//                do {
//                    let rentResponse = try JSONDecoder().decode([ViewData.RentData].self, from: response.data)
////                    self?.insertIntoDBRent(rents: rentResponse)
//                } catch let error {
//                    print("Error in parsing: \(error)")
//                    self?.updateViewData?(.failure(error))
//                }
//            case .failure(let error):
//                let requestError = (error as NSError)
//                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
//                self?.updateViewData?(.failure(error))
//            }
//        }
//    }
    
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
//                if let image = book.image {
//                    fetchImage(image: image, id: book.id)
//                }
               
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
//        updateViewData?(.successImage(arrImages))
        do {
            try dbQueue.read { db in
                let draft = try Books.fetchAll(db)
                updateViewData?(.successBooks(draft))
            }
        } catch {
            print("\(error)")
        }
       
    }
    
//    func insertIntoDBRent(rents: [ViewData.RentData]){
//        for rent in rents{
//            do {
//                try dbQueue.write { db in
//                    var rents = Rents(
//                        id: rent.id,
//                        user_id: rent.user_id,
//                        book_id: rent.book_id,
//                        start_date: rent.start_date,
//                        end_date: rent.end_date
//                    )
//                    try! rents.insert(db)
//                }
//            } catch {
//                print("\(error)")
//            }
//        }
//        do {
//            try dbQueue.read { db in
//                let draft = try Rents.fetchAll(db)
//                print("kokoko\(draft)")
//            }
//        } catch {
//            print("\(error)")
//        }
//    }
    
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
