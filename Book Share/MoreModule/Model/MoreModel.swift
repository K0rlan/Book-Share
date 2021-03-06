//
//  MoreModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 08.03.2021.
//

import Foundation
import UIKit

enum MoreModel {
    case initial
    case loading
    case successBooks([Books])
    case successImage([BooksImages])
    case successRent([RentsData])
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
   
    struct RentsData: Decodable {
        let id: Int
        let user_id: String
        let book_id: Int
        let start_date: String
        let end_date: String?
    }
    
    struct RentData: Decodable {
        let user_id: String
        let book_id: Int
        let start_date: String
        let end_date: String?
    }
}
