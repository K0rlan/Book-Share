//
//  Rents.swift
//  Book Share
//
//  Created by Korlan Omarova on 07.03.2021.
//

import Foundation
import GRDB

struct Rents {
    var id: Int
    var user_id: String
    var book_id: Int
    var start_date: String
    var end_date: String?
}

extension Rents: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let user_id = Column(CodingKeys.user_id)
        static let book_id = Column(CodingKeys.book_id)
        static let start_date = Column(CodingKeys.start_date)
        static let end_date = Column(CodingKeys.end_date)
    }

}
