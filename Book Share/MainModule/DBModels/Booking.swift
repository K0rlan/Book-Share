//
//  Booking.swift
//  Book Share
//
//  Created by Korlan Omarova on 08.03.2021.
//

import Foundation
import GRDB

struct Booking {
    var id: Int
    var user_id: String
    var book_id: Int
    var start_date: String
    var end_date: String?
}

extension Booking: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let user_id = Column(CodingKeys.user_id)
        static let book_id = Column(CodingKeys.book_id)
        static let start_date = Column(CodingKeys.start_date)
        static let end_date = Column(CodingKeys.end_date)
      

    }
    static func filterByBookID(id: Int) -> QueryInterfaceRequest<Booking> {
            return Booking.filter(Columns.book_id == id)
    }


}
