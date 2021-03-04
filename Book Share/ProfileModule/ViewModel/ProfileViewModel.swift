//
//  ProfileViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation

protocol ProfileViewModelProtocol {
    var updateViewData: ((UserProfile)->())? { get set }
    func startFetch()
}

final class ProfileViewModel: ProfileViewModelProtocol{
    var updateViewData: ((UserProfile) -> ())?
    
    
    var user = UserProfile.Data(image: Constants.book, name: "Koko", surname: "Koko", email: "koko@mail.ru",
                                phone: 87072470783)
    
    init() {
        updateViewData?(.initial)
    }
    
    func startFetch() {
        updateViewData?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let user = self?.user else { return }
            self?.updateViewData?(.success(user))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.updateViewData?(.failure)
    }
    
    
}
}
