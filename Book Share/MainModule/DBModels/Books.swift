//
//  Books.swift
//  Book Share
//
//  Created by Korlan Omarova on 06.03.2021.
//

import Foundation
import GRDB

struct Books {
    var id: Int
    var isbn: String
    var title: String
    var author: String
    var image: String?
    var publish_date: String
    var genre_id: Int?
}

extension Books: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let isbn = Column(CodingKeys.isbn)
        static let title = Column(CodingKeys.title)
        static let author = Column(CodingKeys.author)
        static let image = Column(CodingKeys.image)
        static let publish_date = Column(CodingKeys.publish_date)
        static let genre_id = Column(CodingKeys.genre_id)

    }
    static func filterById(id: Int) -> QueryInterfaceRequest<Books> {
            return Books.filter(Columns.id == id)
    }
    static func filterByGenre(id: Int) -> QueryInterfaceRequest<Books> {
            return Books.filter(Columns.genre_id == id)
    }

    static func filterByIsbn(isbn: String) -> QueryInterfaceRequest<Books> {
            return Books.filter(Columns.isbn == isbn)
    }

}
