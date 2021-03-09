////
////  SearchByCodeViewModel.swift
////  Book Share
////
////  Created by Korlan Omarova on 09.03.2021.
////
//
//import Foundation
//import GRDB
//
//protocol SearchByCodeViewModelProtocol {
//    func startFetch(isbn: String) -> Int
//}
//
//final class SearchByCodeViewModel: SearchByCodeViewModelProtocol{
//    
//    func startFetch(isbn: String) -> Int {
//        var bookID: Int!
//            do {
//                try dbQueue.read { db in
//                   let draft = try Books.filterByIsbn(isbn: isbn).fetchAll(db)
//                    print(draft)
//                    bookID = draft.first?.id
//                }
//            } catch {
//                print("\(error)")
//            }
//        return bookID
//    }
//    
//    
//}
