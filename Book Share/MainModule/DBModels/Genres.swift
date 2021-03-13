//
//  Genres.swift
//  Book Share
//
//  Created by Korlan Omarova on 06.03.2021.
//

import Foundation
import GRDB

struct Genres {
    var id: Int
    var title: String
    var sort: Int
    var enabled: Bool?
}

extension Genres: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let title = Column(CodingKeys.title)
        static let sort = Column(CodingKeys.sort)
        static let enabled = Column(CodingKeys.enabled)
    }

    static func filterByName(name: String) -> QueryInterfaceRequest<Genres> {
            return Genres.filter(Columns.title == name)
    }
}
