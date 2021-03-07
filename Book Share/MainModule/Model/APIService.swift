//
//  APIService.swift
//  Dar Library
//
//  Created by Korlan Omarova on 02.03.2021.
//

import Foundation
import Moya

enum APIService {
    case getBooks
    case getGenres
    case getRent
    case getBook(bookID: Int)
    case getImage(imageName: String)
    case postBook(book: ViewData.BooksData)
}

extension APIService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://dar-library.dar-dev.zone/")!
    }
    
    var path: String {
        switch self {
        case .getBooks, .postBook:
            return "api/books"
        case .getGenres:
            return "api/genres"
        case .getBook(let id):
            return "api/books/\(id)"
        case .getRent:
            return "api/rent"
        case .getImage(let imageName):
            return "\(imageName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage:
            return .get
        case .postBook:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage:
            return .requestPlain
        case .postBook(let book):
            let params: [String : Any] = [
                "id" :  book.id,
                "isbn" : book.isbn,
                "title" : book.title,
                "author" : book.author,
                "image" : book.image ?? nil,
                "publish_date" : book.publish_date,
                "genre_id" : book.genre_id ?? nil,
                
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

