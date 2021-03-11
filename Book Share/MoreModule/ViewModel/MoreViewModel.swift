//
//  MoreViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation
import Moya
protocol MoreViewModelProtocol {
    var updateViewData: ((MoreModel)->())? { get set }
    func startFetch()
}

final class MoreViewModel: MoreViewModelProtocol{
    var updateViewData: ((MoreModel) -> ())?
    var bookID: Int
    let provide = MoyaProvider<APIImage>()
    
    var images = [BooksImages]()
    
    init(id: Int) {
        updateViewData?(.initial)
        self.bookID = id
    }
    
    func startFetch() {
        updateViewData?(.loading)
        DispatchQueue.main.async{ [weak self] in
            do {
                try dbQueue.read { db in
                    if self?.bookID == 0{
                        let draft = try Books.fetchAll(db)
                        self?.updateViewData?(.successBooks(draft))
                        self?.fetchImages(books: draft)
                    }else{
                        let draft = try Books.filterByGenre(id: self!.bookID).fetchAll(db)
                        self?.updateViewData?(.successBooks(draft))
                        self?.fetchImages(books: draft)
                    }
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    
    func fetchImages(books: [Books]){
        DispatchQueue.main.async { [weak self] in
            for book in books{
                do {
                    try dbQueue.read { db in
                        let draft = try BooksImages.filterById(id: book.id).fetchAll(db)
                        print(draft)
                        self?.images.append(contentsOf: draft)
                        self?.updateViewData?(.successImage(self!.images))
                    }
                } catch {
                    print("\(error)")
                }
            }
        }
    }
}
