//
//  CreateViewModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import Moya
import UIKit
import Griffon_ios_spm

protocol CreateViewModelProtocol {
    func addBook(book: CreateBook)
    var updateViewData: ((GenresResponse)->())? { get set }
}

class CreateViewModel: CreateViewModelProtocol{
    let provider = MoyaProvider<APIService>()
    let providerImage = MoyaProvider<APIImage>()
    var updateViewData: ((GenresResponse)->())?
 
    init() {
        updateViewData?(.initial)
    }
    
    func addBook(book: CreateBook){
        provider.request(.postBook(book: book)) { [weak self] (result) in
                switch result{
                case .success(let response):
                    print(response)
                case .failure(let error):
                    let requestError = (error as NSError)
                    print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                    
                }
            }
        }
    
    func getGenres(){
        updateViewData?(.loading)
        DispatchQueue.main.async { [weak self] in
            do {
                try dbQueue.read { db in
                    let draft = try Genres.fetchAll(db)
                    self?.updateViewData?(.success(draft))
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    func getGenre(name: String){
        updateViewData?(.loading)
        DispatchQueue.main.async { [weak self] in
            do {
                try dbQueue.read { db in
                    let draft = try Genres.filterByName(name: name).fetchAll(db)
                    self?.updateViewData?(.successGenre(draft.first!))
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    func uploadImage(image: UIImage){
        provider.request(.postImage(image: image)) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: String]{
                        if let path = jsonResponse["path"] as? String {
                            print(path)
                            self?.updateViewData?(.successImage(path))
                        }
                    }
                } catch let error {
                    print("Error in parsing: \(error)")

                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                
            }
        }
    }
}
