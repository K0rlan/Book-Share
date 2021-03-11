//
//  BooksImages.swift
//  Book Share
//
//  Created by Korlan Omarova on 11.03.2021.
//

import Foundation
import GRDB

struct BooksImages {
    var id: Int
    var image: Data?
}

extension BooksImages: Codable, FetchableRecord, MutablePersistableRecord {

    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let image = Column(CodingKeys.image)
    }
    
    static func filterById(id: Int) -> QueryInterfaceRequest<BooksImages> {
            return BooksImages.filter(Columns.id == id)
    }
}
