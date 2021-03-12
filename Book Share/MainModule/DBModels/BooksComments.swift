//
//  BooksComments.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import GRDB

struct BooksComments {
    var id: Int
    var user_id: String
    var user_contact: String
    var user_name: String
    var book_id: Int
    var text: String
}

extension BooksComments: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let user_id = Column(CodingKeys.user_id)
        static let user_contact = Column(CodingKeys.user_contact)
        static let user_name = Column(CodingKeys.user_name)
        static let book_id = Column(CodingKeys.book_id)
        static let text = Column(CodingKeys.text)
    }
    
    static func filterByBookId(id: Int) -> QueryInterfaceRequest<BooksComments> {
            return BooksComments.filter(Columns.book_id == id)
    }
}
