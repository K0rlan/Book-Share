//
//  DetailsViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation
import Moya
import Griffon_ios_spm
import FirebaseFirestore

protocol DetailsViewModelProtocol {
    var updateViewData: ((DetailsData)->())? { get set }
    var updateRoles: ((RolesViewData)->())? { get set }
    var updateComments: ((CommentResponse)->())? { get set }
    func startFetch()
}

class DetailsViewModel: DetailsViewModelProtocol{
    var updateViewData: ((DetailsData) -> ())?
    var updateRoles: ((RolesViewData)->())?
    var updateComments: ((CommentResponse)->())?
    let bookID: Int
    let provider = MoyaProvider<APIService>()
    let imageProvider = MoyaProvider<APIImage>()
    
    init(bookID: Int) {
        updateViewData?(.initial)
        updateRoles?(.initial)
        updateComments?(.initial)
        self.bookID = bookID
    }
    
    func getBookID() -> Int {
        return bookID
    }
    
    func deleteBook(){
        provider.request(.deleteBook(id: bookID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
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
    
    func deleteComment(id: Int){
        provider.request(.deleteComment(id: id)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                } catch let error {
                    print("Error in parsing: \(error)")
                    self?.updateComments?(.failure(error))
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                self?.updateComments?(.failure(error))
            }
        }
    }
    
    func fetchImages(image: String?){
        if let img = image{
            imageProvider.request(.getImage(imageName: img)) { [weak self] (result) in
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
        getComments()
        
        updateViewData?(.loading)
        provider.request(.getBook(bookID: bookID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let bookResponse = try JSONDecoder().decode(DetailsData.Data.self, from: response.data)
                    self?.insertIntoDBBook(book: bookResponse)
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
    
    func getComments() {
        refreshComments()
        
        provider.request(.getComments) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let comments = try JSONDecoder().decode([CommentResponse.Data].self, from: response.data)
                    self?.insertIntoDBComments(comments: comments)
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
                try db.execute(sql: "DELETE FROM booksComments")
            }
        } catch {
            print("\(error)")
        }
        
    }
    
    func refreshComments(){
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM booksComments")
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
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    
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
        refreshTables()
        fetchRents()
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
    
    func insertIntoDBComments(comments: [CommentResponse.Data]){
        for comment in comments{
            do {
                try dbQueue.write { db in
                    var booksComments = BooksComments(
                        id: comment.id,
                        user_id: comment.user_id,
                        user_contact: comment.user_contact,
                        user_name: comment.user_name,
                        book_id: comment.book_id,
                        text: comment.text
                    )
                    try! booksComments.insert(db)
                }
            } catch {
                print("\(error)")
            }
        }
        do {
            try dbQueue.read { [weak self] db in
                let draft = try BooksComments.filterByBookId(id: bookID).fetchAll(db)
                self?.updateComments?(.success(draft))
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
        getBookStatus()
        
    }
    func putBook(id: Int, enabled: Bool){
        provider.request(.updateRent(id: id, enabled: enabled)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
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
    func getRole(){
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
    
    func addComment(text: String){
        let comment = CommentResponse.CreateData(user_id: Utils.getUserID(), user_contact: (Griffon.shared.getUserProfiles()?.email)!, user_name: "Koko", book_id: bookID, text: text)
        postComment(comment: comment)
        
    }
    
    func putComment(id: Int, text: String){
        provider.request(.updateComment(id: id, text: text)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                } catch let error {
                    print("Error in parsing: \(error)")
                    self?.updateComments?(.failure(error))
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                self?.updateComments?(.failure(error))
                
            }
        }
    }
    
    func postComment(comment: CommentResponse.CreateData){
        provider.request(.postComment(comment: comment)) { [weak self] (result) in
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
    }
    
    func adminSendPush(){
        do {
            try dbQueue.read { [weak self] db in
                let draft = try BookRent.filterByBookID(id: bookID).fetchAll(db)
                let userId = draft.first?.user_id
                self?.getUserFCM(userId: userId!)
                
            }
        } catch {
            print("\(error)")
        }
    }
    
    func getUserFCM(userId: String){
        let db = Firestore.firestore()
        db.collection("users_table").whereField("user_id", isEqualTo: userId).getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dict = TokenFirebase(dictionary: document.data())
                    print(dict.fcm)
                    self?.sendPush(fcm: dict.fcm)
                }
                
            }
        }
    }
    
    func sendPush(fcm: String){
        let notifPayload: [String: Any] = ["to": fcm,"notification": ["title":"You have expired books.", "body":"You need to hand over expired books","badge":1,"sound":"default"]]
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
