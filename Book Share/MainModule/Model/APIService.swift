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
    case postRent(rent: ViewData.RentData)
    case deleteRent(rentId: Int)
    case updateRent(id: Int, enabled: Bool)
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
        case .updateRent(let id, let _):
            return "api/books/\(id)"
        case .getRent, .postRent:
            return "api/rent"
        case .getImage(let imageName):
            return "\(imageName)"
        case .deleteRent(let rentId):
            return "api/rent/\(rentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage:
            return .get
        case .postBook, .postRent:
            return .post
        case .deleteRent:
            return .delete
        case .updateRent:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage, .deleteRent:
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
            
        case .postRent(let rent):
            let bookParams: [String : Any] = [
                "id" :  rent.book!.id,
                "isbn" : rent.book!.isbn,
                "title" : rent.book!.title,
                "author" : rent.book!.author,
                "image" : rent.book!.image ?? nil,
                "publish_date" : rent.book!.publish_date,
                "genre_id" : rent.book!.genre_id ?? nil,
                "enabled" : rent.book!.enabled,
            ]
            let params: [String : Any] = [
                "user_id" : rent.user_id,
                "user_contact" : rent.user_contact ?? nil,
                "user_name" : rent.user_name ?? nil,
                "book_id" : rent.book_id,
                "start_date" : rent.start_date,
                "end_date" : rent.end_date ?? nil,
                "book" : bookParams ?? nil,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        
        case .updateRent(let _, let enabled):
            let params: [String : Any] = [
                "enabled" : enabled
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

