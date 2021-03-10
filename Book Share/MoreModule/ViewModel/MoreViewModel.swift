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
    
    var images = [MoreModel.BooksImages]()
    
    init(id: Int) {
        updateViewData?(.initial)
        self.bookID = id
    }
    
    func startFetch() {
        updateViewData?(.loading)
        DispatchQueue.main.async { [weak self] in
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
        for book in books{
            if let img = book.image{
                provide.request(.getImage(imageName: img)) { [weak self] (result) in
                    switch result{
                    case .success(let response):
                        do {
                            let img = try response.mapImage().jpegData(compressionQuality: 1)
                            let book = MoreModel.BooksImages(id: book.id, image: img)
                            self?.images.append(book)
                            self?.updateViewData?(.successImage(self!.images))
                        } catch let error {
                            print("Error in parsing: \(error)")
                            self?.updateViewData?(.failure(error))
                        }
                    case .failure(let error):
                        let requestError = (error as NSError)
                        print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                        self?.updateViewData?(.failure(error))
                    }
                }
            }
        }
    }
}
