//
//  ReservedBooksViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Moya
import Griffon_ios_spm

protocol ReservedBooksViewModelProtocol {
    var updateViewData: ((ReservedBooksViewData)->())? { get set }
    func startFetch()
}

final class ReservedBooksViewModel: ReservedBooksViewModelProtocol{
    var updateViewData: ((ReservedBooksViewData) -> ())?
    let provider = MoyaProvider<APIService>()
    let provide = MoyaProvider<APIImage>()
    
    
    init() {
        updateViewData?(.initial)
    }
    
    var images = [BooksImages]()
    
    func startFetch() {
        updateViewData?(.loading)
        
        provider.request(.getUserBooks(userID: "\(Griffon.shared.getUserProfiles()!.id)")) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let readingResponse = try JSONDecoder().decode([ReservedBooksViewData.RentsData].self, from: response.data)
                    self?.fetchImages(books: readingResponse)
                    self?.updateViewData?(.success(readingResponse))
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
    
    func fetchImages(books: [ReservedBooksViewData.RentsData]){
        DispatchQueue.main.async { [weak self] in
            for book in books{
                do {
                    try dbQueue.read { db in
                        let draft = try BooksImages.filterById(id: book.book_id).fetchAll(db)
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
