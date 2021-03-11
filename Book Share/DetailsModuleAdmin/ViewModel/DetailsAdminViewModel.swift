//
//  DetailsAdminViewModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import Moya
import Griffon_ios_spm

protocol DetailsAdminViewModelProtocol {
    var updateViewData: ((DetailsData)->())? { get set }
    func startFetch()
}

class DetailsAdminViewModel: DetailsViewModelProtocol{
    var updateViewData: ((DetailsData) -> ())?
    let bookID: Int
    let provider = MoyaProvider<APIService>()
    let provide = MoyaProvider<APIImage>()
    
    init(bookID: Int) {
        updateViewData?(.initial)
        self.bookID = bookID
    }
    
    func getBookID() -> Int {
        return bookID
    }
    
    func deleteBook(){
        provider.request(.deleteBook(id: bookID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                    print(response)
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                
            }
        }
    }
    
    func fetchImages(image: String?){
        if let img = image{
            provide.request(.getImage(imageName: img)) { [weak self] (result) in
                switch result{
                case .success(let response):
                    do {
                        let img = try response.mapImage()
                        self?.updateViewData?(.successImage(img))
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
    
    func startFetch() {
        provider.request(.getBook(bookID: bookID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let bookResponse = try JSONDecoder().decode(DetailsData.Data.self, from: response.data)
                    self?.insertIntoDBBook(book: bookResponse)
                    print(bookResponse)
                    self?.updateViewData?(.success(bookResponse))
                    self?.fetchImages(image: bookResponse.image)
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
    
    
    func getBookStatus() {
        DispatchQueue.main.async { [weak self] in
        do {
            try dbQueue.read { [weak self] db in
                let bookIsTaken = try BookRent.filterByBookID(id: self!.bookID).fetchAll(db)
                if bookIsTaken.isEmpty {
                    self?.updateViewData?(.bookStatus(BookStatus.available))
                } else {
                    self?.updateViewData?(.bookStatus(BookStatus.notAvailable))
                    
                }
            }
        } catch {
            print("\(error)")
        }
        }
    }
    
    func refreshTables(){
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM bookRent")
                try db.execute(sql: "DELETE FROM bookDetails")
            }
        } catch {
            print("\(error)")
        }
        
    }
    
    
    func fetchRents(){
        provider.request(.getRent) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let rentsResponse = try JSONDecoder().decode([ViewData.RentsData].self, from: response.data)
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
    
    func insertIntoDBRents(rents: [ViewData.RentsData]){
        for rent in rents{
            do {
                try dbQueue.write { db in
                    var rents = BookRent(
                        id: rent.id,
                        user_id: rent.user_id,
                        user_contact: rent.user_contact,
                        user_name: rent.user_name,
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
        do {
            try dbQueue.read { db in
                let draft = try BookRent.fetchAll(db)
               print("koko\(draft)")
            }
        } catch {
            print("\(error)")
        }
    }
    func insertIntoDBBook(book: DetailsData.Data){
        do {
            try dbQueue.write { db in
                var book = BookDetails(
                    id: book.id,
                    isbn: book.isbn,
                    title: book.title,
                    author: book.author,
                    image: book.image,
                    publish_date: book.publish_date,
                    genre_id: book.genre_id,
                    enabled: book.enabled
                )
                
                try! book.insert(db)
            }
        } catch {
            print("\(error)")
        }
        do {
            try dbQueue.read { db in
                let draft = try BookDetails.fetchAll(db)
               print("koko\(draft)")
            }
        } catch {
            print("\(error)")
        }
        getBookStatus()
        
    }
    
    
}
