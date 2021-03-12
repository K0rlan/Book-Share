//
//  ReservedBooksViewData.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import UIKit

enum ReservedBooksViewData {
    case initial
    case loading
    case success([RentsData])
    case successImage([BooksImages])
    case failure(Error)
    
    struct BookData: Decodable {
        let id: Int
        let isbn: String
        let image: String?
        let title: String
        let author: String
        let publish_date: String
        let genre_id: Int?
        let enabled: Bool
    }
    
    struct RentsData: Decodable {
        let id: Int
        let user_id: String
        let user_contact: String?
        let user_name: String?
        let book_id: Int
        let start_date: String
        let end_date: String?
        let book: BookData?
    }
}
