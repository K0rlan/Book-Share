//
//  EditViewModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import Moya
import Griffon_ios_spm

protocol EditViewModelProtocol {
    var updateViewData: ((DetailsData)->())? { get set }
    func startFetch()
}

class EditViewModel: EditViewModelProtocol{
    var updateViewData: ((DetailsData) -> ())?
    let bookID: Int
    let provider = MoyaProvider<APIService>()
    let provide = MoyaProvider<APIImage>()
    
    init(bookID: Int) {
        updateViewData?(.initial)
        self.bookID = bookID
    }
    
    func fetchImages(image: String?){
        if let img = image{
            provide.request(.getImage(imageName: img)) { [weak self] (result) in
                switch result{
                case .success(let response):
                    do {
                        let img = try response.mapImage()
                        self?.updateViewData?(.successImage(img))
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
    
    func startFetch() {
        updateViewData?(.loading)
        provider.request(.getBook(bookID: bookID)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let bookResponse = try JSONDecoder().decode(DetailsData.Data.self, from: response.data)
                    print(bookResponse)
                    self?.updateViewData?(.success(bookResponse))
                    self?.fetchImages(image: bookResponse.image)
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
    
    func putBook(book: EditBook){
        provider.request(.updateBook(id: bookID, book: book)) { [weak self] (result) in
                switch result{
                case .success(let response):
                    print(response)
                case .failure(let error):
                    let requestError = (error as NSError)
                    print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                    
                }
            }
        }
    
    
}
