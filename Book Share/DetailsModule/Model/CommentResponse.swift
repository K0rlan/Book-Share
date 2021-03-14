//
//  CommentResponse.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation

enum CommentResponse {
    case initial
    case loading
    case success([BooksComments])
    case failure(Error)

    struct Data: Decodable {
        let id: Int
        let user_id: String
        let user_contact: String
        let user_name: String
        let book_id: Int
        let text: String
    }
    
    struct CreateData: Decodable {
        let user_id: String
        let user_contact: String
        let user_name: String
        let book_id: Int
        let text: String
    }
}
