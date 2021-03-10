//
//  BookDetails.swift
//  Book Share
//
//  Created by Korlan Omarova on 10.03.2021.
//

import Foundation
import GRDB

struct BookDetails {
    var id: Int
    var isbn: String
    var title: String
    var author: String
    var image: String?
    var publish_date: String
    var genre_id: Int?
    var enabled: Bool
}

extension BookDetails: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let isbn = Column(CodingKeys.isbn)
        static let title = Column(CodingKeys.title)
        static let author = Column(CodingKeys.author)
        static let image = Column(CodingKeys.image)
        static let publish_date = Column(CodingKeys.publish_date)
        static let genre_id = Column(CodingKeys.genre_id)
        static let enabled = Column(CodingKeys.enabled)

    }

}
