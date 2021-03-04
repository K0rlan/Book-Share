//
//  MainViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Moya

protocol MainViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MainViewModel: MainViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    let provider = MoyaProvider<APIService>()


    init() {
        updateViewData?(.initial)
    }

    func startFetch() {
        updateViewData?(.loading)
        
        fetchBooks()
        fetchGenres()
    }
    
    func fetchBooks(){
        provider.request(.getBooks) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let booksResponse = try JSONDecoder().decode([ViewData.BooksData].self, from: response.data)
                    self?.updateViewData?(.successBooks(booksResponse))
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
    
    func fetchGenres(){
        provider.request(.getGenres) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let genresResponse = try JSONDecoder().decode([ViewData.GenresData].self, from: response.data)
                    self?.updateViewData?(.successGenres(genresResponse))
//                    self?.addBook()
//                    self?.addImage()
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
