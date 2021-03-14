//
//  MoreViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation
import Moya
import FirebaseFirestore
import Griffon_ios_spm

protocol MoreViewModelProtocol {
    var updateViewData: ((MoreModel)->())? { get set }
    var updateRoles: ((RolesViewData)->())? { get set }
    func startFetch()
}

final class MoreViewModel: MoreViewModelProtocol{
    var updateViewData: ((MoreModel) -> ())?
    var updateRoles: ((RolesViewData)->())?
    var bookID: Int
    
    var images = [BooksImages]()
    
    init(id: Int) {
        updateViewData?(.initial)
        updateRoles?(.initial)
        self.bookID = id
    }
    
    func startFetch() {
        updateViewData?(.loading)
        DispatchQueue.main.async{ [weak self] in
            do {
                try dbQueue.read { db in
                    if self?.bookID == 0{
                        let draft = try Books.fetchAll(db)
                        self?.updateViewData?(.successBooks(draft))
                        self?.fetchImages(books: draft)
                    }else{
                        let draft = try Books.filterByGenre(id: self!.bookID).fetchAll(db)
                        self?.updateViewData?(.successBooks(draft))
                        self?.fetchImages(books: draft)
                    }
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
    
    func fetchImages(books: [Books]){
        DispatchQueue.main.async { [weak self] in
            for book in books{
                do {
                    try dbQueue.read { db in
                        let draft = try BooksImages.filterById(id: book.id).fetchAll(db)
                        self?.images.append(contentsOf: draft)
                        self?.updateViewData?(.successImage(self!.images))
                    }
                } catch {
                    print("\(error)")
                    self?.updateViewData?(.failure(error))
                }
            }
        }
    }
    
    func logout() {
        Griffon.shared.cleanKeyChain()
        Griffon.shared.signInModel = nil
        Griffon.shared.signUpModel = nil
    }
}
