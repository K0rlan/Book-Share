//
//  DetailsViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation
import Moya
import Griffon_ios_spm

protocol DetailsViewModelProtocol {
    var updateViewData: ((DetailsData)->())? { get set }
    func startFetch()
}

class DetailsViewModel: DetailsViewModelProtocol{
    var updateViewData: ((DetailsData) -> ())?
    let bookID: Int
    let provider = MoyaProvider<APIService>()
    let provide = MoyaProvider<APIImage>()
    init(bookID: Int) {
        updateViewData?(.initial)
        self.bookID = bookID
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
                let bookIsTakenByThisUser = try BookRent.filterByUserID(userId: Griffon.shared.getUserProfiles()!.id, bookId: self!.bookID).fetchAll(db)
                if !bookIsTakenByThisUser.isEmpty {
                    self?.updateViewData?(.bookStatus(BookStatus.canReturnBook))
                } else if !bookIsTaken.isEmpty, bookIsTakenByThisUser.isEmpty {
                    self?.updateViewData?(.bookStatus(BookStatus.notAvailable))
                } else {
                    self?.updateViewData?(.bookStatus(BookStatus.available))
                }
            }
        } catch {
            print("\(error)")
        }
        }
    }
    
    func addRent(){
//        let calendar = Calendar.current
//        let addTwoWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: 2, to: Date())
        var book: BookDetails!
        do {
            try dbQueue.read { db in
                let draft = try BookDetails.fetchAll(db)
                book = draft.first!
            }
        } catch {
            print("\(error)")
        }
        let rent = ViewData.RentData(user_id: "\(Griffon.shared.getUserProfiles()!.id)", user_contact: "\((Griffon.shared.getUserProfiles()!.email)!)", user_name: "nil", book_id: bookID, start_date: "\(Date())", end_date: nil, book: book!)
        provider.request(.postRent(rent: rent)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]{
                        print(jsonResponse)
                    }

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
        refreshTables()
        fetchRents()
        putBook(id: bookID, enabled: false)
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
    
    func deleteRent(){
        var rentID = Int()
        do {
            try dbQueue.read { db in
                let draft = try BookRent.filterByBookID(id: self.bookID).fetchAll(db)
                if !draft.isEmpty{
                    rentID = draft.first!.id
                    print(rentID)}
            }
        } catch {
            print("\(error)")
        }
        provider.request(.deleteRent(rentId: rentID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: String]{
                        print(jsonResponse)
                    }
                    
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
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM bookRent WHERE id = \(rentID)")
            }
        } catch {
            print("\(error)")
        }
        putBook(id: bookID, enabled: true)
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
        getBookStatus()
        
    }
    func putBook(id: Int, enabled: Bool){
        provider.request(.updateRent(id: id, enabled: enabled)) { [weak self] (result) in
            switch result{
            case .success(let response):
                print(response)
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                
            }
        }
    }
    
    
}
