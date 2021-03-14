//
//  MainViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Moya
import UIKit
import FirebaseFirestore
import Griffon_ios_spm

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    var updateImages: ((ViewImages)->())? { get set }
    var updateRoles: ((RolesViewData)->())? { get set }
    var updateRent: ((RentModel) ->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    var updateImages: ((ViewImages)->())?
    var updateRoles: ((RolesViewData)->())?
    var updateRent: ((RentModel) ->())?
    
    let provider = MoyaProvider<APIService>()
    var images = [ViewImages.BooksImages]()
    
    let imageProvider = MoyaProvider<APIImage>()
    init() {
        updateViewData?(.initial)
        updateImages?(.initial)
        updateRoles?(.initial)
        updateRent?(.initial)
    }
    
    func startFetch() {
        refreshTables()
        fetchBooks()
        fetchRents()
    }
    
    func fetchBooks(){
        updateViewData?(.loading)
        provider.request(.getBooks) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let booksResponse = try JSONDecoder().decode([ViewData.BooksData].self, from: response.data)
                    self?.fetchImages(books: booksResponse)
                    self?.updateViewData?(.successBooks(booksResponse))
                    self?.fetchGenres()
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
        updateImages?(.loading)
        for book in books{
            if let img = book.image{
                imageProvider.request(.getImage(imageName: img)) { [weak self] (result) in
                    switch result{
                    case .success(let response):
                        do {
                            let img = try response.mapImage().jpegData(compressionQuality: 1)
                            let book = ViewImages.BooksImages(id: book.id, image: img)
                            self?.images.append(book)
                            self?.updateImages?(.successImage(self!.images))
                            self?.insertIntoDBImages(books: book)
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
                try db.execute(sql: "DELETE FROM bookRent")
                try db.execute(sql: "DELETE FROM booksImages")
            }
        } catch {
            print("\(error)")
        }
    }
    
    func insertIntoDBImages(books: ViewImages.BooksImages){
        do {
            try dbQueue.write { db in
                var books = BooksImages(
                    id: books.id,
                    image: books.image
                )
                try! books.insert(db)
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
        
        DispatchQueue.main.async { [weak self] in
            do {
                try dbQueue.read { db in
                    let draft = try BookRent.fetchAll(db)
                    self?.updateRent?(.success(draft))
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
                self?.updateViewData?(.failure(error))
            }
        }
    }
    
    func getRole(){
        updateRoles?(.loading)
        let db = Firestore.firestore()
        let userID = Utils.getUserID()
        db.collection("roles").whereField("user_id", isEqualTo: userID).getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self?.updateRoles?(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    self?.updateRoles?(.success(RolesViewData.Roles(dictionary: document.data())))
                }
                
            }
        }
        
    }
    
    func setRole() {
        let userID = Utils.getUserID()
        let db = Firestore.firestore()
        db.collection("roles").addDocument(data: [
            "user_id": userID,
            "role": "user"
        ]) { err in
            if let err = err {
                print("Error saving user data: \(err)")
            }
        }
    }
    
    func saveUserToken(){
        let userID = Griffon.shared.getUserProfiles()!.id
        let db = Firestore.firestore()
        db.collection("users_table").addDocument(data: [
            "user_id": userID,
            "fcm_token": Constants.userToken
        ]) { err in
            if let err = err {
                print("Error saving user data: \(err)")
            }
        }
    }
    
    func logout() {
        Griffon.shared.cleanKeyChain()
        Griffon.shared.signInModel = nil
        Griffon.shared.signUpModel = nil
    }
    
    func requestForBook(title: String, author: String){
        let db = Firestore.firestore()
        db.collection("bookRequest").addDocument(data: [
            "author": author,
            "title": title
        ]) { err in
            if let err = err {
                print("Error saving user data: \(err)")
            }
        }
    }
    
    func getExpiredBooks(){
        do {
            try dbQueue.read { db in
                var booksPush = [Books]()
                let draft = try BookRent.filterByUser(userId: Utils.getUserID()).fetchAll(db)
                print(draft)
                for book in draft {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date = dateFormatter.date(from: book.start_date)!
                    let calendar = Calendar.current
                    let addOneWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: date)
                    if addOneWeekToCurrentDate! < Date(){
                        let b = try Books.filterById(id: book.book_id).fetchAll(db)
                        booksPush.append(contentsOf: b)
                    }
                    
                }
                if !booksPush.isEmpty{
                    sendPush(book: booksPush)
                }
                
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    
    func sendPush(book: [Books]){
        let userToken = Constants.userToken
        print(userToken)
        var a = String()
        for book in book {
            a += "\n\(book.title)"
        }
        let notifPayload: [String: Any] = ["to": userToken,"notification": ["title":"You have expired books.", "body":"You need to hand over: \(a)","badge":1,"sound":"default"]]
        self.sendPushNotification(payloadDict: notifPayload)
    }
    
    func sendPushNotification(payloadDict: [String: Any]) {
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(Constants.serverKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print(response ?? "")
            }
            print("Notfication sent successfully.")
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "")
        }
        task.resume()
    }
}
