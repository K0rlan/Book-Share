//
//  APIService.swift
//  Dar Library
//
//  Created by Korlan Omarova on 02.03.2021.
//

import Foundation
import Moya
import UIKit

enum APIService {
    case getBooks
    case getBook(bookID: Int)
    case postBook(book: CreateBook)
    case updateBook(id: Int, book: EditBook)
    case deleteBook(id: Int)
    case getGenres
    case getRent
    case postRent(rent: ViewData.RentData)
    case deleteRent(rentId: Int)
    case updateRent(id: Int, enabled: Bool)
    case getUserBooks(userID: String)
    case getImage(imageName: String)
    case postImage(image: UIImage)
    case postComment(comment: CommentResponse.CreateData)
    case getComments
    case updateComment(id: Int, text: String)
    case deleteComment(id: Int)
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
        case .getUserBooks(let userID):
            return "api/rent/reading/\(userID)"
        case .updateBook(let id, let _):
            return "api/books/\(id)"
        case .deleteBook(let id):
            return "api/books/\(id)"
        case .postComment, .getComments:
            return "api/comments"
        case .deleteComment(let id):
            return "api/comments/\(id)"
        case .updateComment(let id, let _):
            return "api/comments/\(id)"
        case .postImage:
            return "api/file-upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage, .getUserBooks, .getComments:
            return .get
        case .postBook, .postRent, .postComment, .postImage:
            return .post
        case .deleteRent, .deleteBook, .deleteComment:
            return .delete
        case .updateRent, .updateBook, .updateComment:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getBooks, .getGenres, .getBook, .getRent, .getImage, .deleteRent, .getUserBooks, .deleteBook, .getComments, .deleteComment:
            return .requestPlain
        case .postBook(let book):
            let params: [String : Any] = [
                "isbn" : book.isbn,
                "title" : book.title,
                "author" : book.author,
                "image" : book.image ?? nil,
                "publish_date" : book.publish_date,
                "enabled" : book.enabled,
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
            
        case .updateBook(let _, let book):
            let params: [String : Any] = [
                "isbn" : book.isbn,
                "title" : book.title,
                "author" : book.author,
                "image" : book.image,
                "publish_date" : book.publish_date,
                "enabled" : book.enabled,
                "genre_id" : book.genre_id ?? nil,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updateComment(let _, let text):
            let params: [String : Any] = [
                "text" : text
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .postComment(let comment):
            let params: [String : Any] = [
                "user_id" : comment.user_id,
                "user_contact" : comment.user_contact,
                "user_name" : comment.user_name,
                "book_id" : comment.book_id,
                "text" : comment.text
                
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .postImage(let image):
            let imageData = image.jpegData(compressionQuality: 1.0)!
            return .uploadMultipart([MultipartFormData(provider: .data(imageData),
                                                       name: "image",
                                                       fileName: "bookImage.jpg",
                                                       mimeType: "image/jpg")])
        }
        
        
    }
    
    var headers: [String : String]? {
        return nil
    }
}

