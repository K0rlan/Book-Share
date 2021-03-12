//
//  BookRent.swift
//  Book Share
//
//  Created by Korlan Omarova on 08.03.2021.
//

import Foundation
import GRDB

struct BookRent {
    var id: Int
    var user_id: String
    var user_contact: String?
    var user_name: String?
    var book_id: Int
    var start_date: String
    var end_date: String?
}

extension BookRent: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let user_id = Column(CodingKeys.user_id)
        static let user_contact = Column(CodingKeys.user_contact)
        static let user_name = Column(CodingKeys.user_name)
        static let book_id = Column(CodingKeys.book_id)
        static let start_date = Column(CodingKeys.start_date)
        static let end_date = Column(CodingKeys.end_date)
      

    }
    static func filterByBookID(id: Int) -> QueryInterfaceRequest<BookRent> {
            return BookRent.filter(Columns.book_id == id)
    }

    static func filterByUserID(userId: String, bookId: Int) -> QueryInterfaceRequest<BookRent> {
            return BookRent.filter(Columns.user_id == userId && Columns.book_id == bookId)
    }
    
    static func filterByUser(userId: String) -> QueryInterfaceRequest<BookRent> {
            return BookRent.filter(Columns.user_id == userId)
    }

}
