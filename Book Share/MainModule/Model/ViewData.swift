//
//  ViewData.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import Foundation
import UIKit

enum ViewData {
    case initial
    case loading
    case successGenres([GenresData])
    case successBooks([BooksData])
    case failure(Error)

    struct BooksData: Decodable {
        let id: Int
        let isbn: String
        let title: String
        let author: String
        let image: String?
        let publish_date: String
        let genre_id: Int?
    }
    
    struct GenresData: Decodable {
        let id: Int
        let title: String
        let sort: Int
        let enabled: Bool?
    }
}

