//
//  ProfileViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import Griffon_ios_spm
import Moya
protocol ProfileViewModelProtocol {
    var updateViewData: ((UserProfile)->())? { get set }
    func startFetch()
}

final class ProfileViewModel: ProfileViewModelProtocol{
    var updateViewData: ((UserProfile) -> ())?
    var updateViewImages: ((ViewImages) -> ())?
    let provider = MoyaProvider<APIService>()
    let provide = MoyaProvider<APIImage>()
    var user = UserProfile.UserData(image: Constants.book, name: "Koko", surname: "Koko", email: "koko@mail.ru",
                                phone: 87072470783)
    var images = [ViewImages.BooksImages]()
    
    init() {
        updateViewData?(.initial)
        updateViewImages?(.initial)
    }
    
    func startFetch() {
        updateViewData?(.loading)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let user = self?.user else { return }
            self?.updateViewData?(.success(user))
        }
        provider.request(.getUserBooks(userID: "\(Griffon.shared.getUserProfiles()!.id)")) { [weak self] (result) in
            switch result{
            case .success(let response):
                do {
                    let readingResponse = try JSONDecoder().decode([UserProfile.RentsData].self, from: response.data)
                    self?.fetchImages(books: readingResponse)
                    self?.updateViewData?(.successReading(readingResponse))
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
    
    func fetchImages(books: [UserProfile.RentsData]){
        updateViewImages?(.loading)
        for book in books{
            if let img = book.book?.image{
                provide.request(.getImage(imageName: img)) { [weak self] (result) in
                    switch result{
                    case .success(let response):
                        do {
                            let img = try response.mapImage().jpegData(compressionQuality: 1)
                            let book = ViewImages.BooksImages(id: book.id, image: img)
                            self?.images.append(book)
                            self?.updateViewImages?(.successImage(self!.images))
                        } catch let error {
                            print("Error in parsing: \(error)")
                            self?.updateViewImages?(.failure(error))
                        }
                    case .failure(let error):
                        let requestError = (error as NSError)
                        print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
                        self?.updateViewImages?(.failure(error))
                    }
                }
            }
        }
    }
    
    
}

