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
    case successGenres([Genres])
    case successBooks([Books])
    case successImage(BooksImages)
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
    
    struct BooksImages: Decodable {
        var id: Int
        var image: Data?
    }
    
    struct RentData: Decodable {
        let id: Int
        let user_id: String
        let book_id: Int
        let start_date: String
        let end_date: String?
    }
}

