//
//  MoreViewModel.swift
//  Dar Library
//
//  Created by Korlan Omarova on 28.02.2021.
//

import Foundation

protocol MoreViewModelProtocol {
    var updateViewData: ((ViewData)->())? { get set }
    func startFetch()
}

final class MoreViewModel: MoreViewModelProtocol{
    var updateViewData: ((ViewData) -> ())?
    var bookID: Int
    
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
                }else{
                let draft = try Books.filterByGenre(id: self!.bookID).fetchAll(db)
                print(draft)
                self?.updateViewData?(.successBooks(draft))
                }
            }
        } catch {
            print("\(error)")
        }
    }
    }
}
