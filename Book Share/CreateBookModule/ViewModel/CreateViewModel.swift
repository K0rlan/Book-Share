//
//  CreateViewModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 12.03.2021.
//

import Foundation
import Moya
import Griffon_ios_spm

protocol CreateViewModelProtocol {
    func addBook(book: CreateBook)
}

class CreateViewModel: CreateViewModelProtocol{
    let provider = MoyaProvider<APIService>()
 
    
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
    
    
}
