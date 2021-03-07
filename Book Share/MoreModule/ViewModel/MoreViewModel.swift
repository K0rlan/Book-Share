//
//  MoreViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation
import Moya
protocol MoreViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MoreViewModel: MoreViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    var bookID: Int
    let provide = MoyaProvider<APIImage>()
    
    init(id: Int) {
        updateViewData?(.initial)
        self.bookID = id
    }
    
    func startFetch() {
        updateViewData?(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            do {
                try dbQueue.read { db in
                    print(self?.bookID)
                    if self?.bookID == 0{
                        let draft = try Books.fetchAll(db)
                        self?.updateViewData?(.successBooks(draft))
                        self?.fetchImages(books: draft)
                    }else{
                        let draft = try Books.filterByGenre(id: self!.bookID).fetchAll(db)
                        print(draft)
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
                            let book = ViewData.BooksImages(id: book.id, image: img)
                            self?.updateViewData?(.successImage(book))
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
