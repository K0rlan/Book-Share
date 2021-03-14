//
//  GenresResponse.swift
//  Book Share
//
//  Created by Korlan Omarova on 13.03.2021.
//

import Foundation

enum GenresResponse {
    case initial
    case loading
    case success([Genres])
    case successImage(String)
    case successGenre(Genres)
    case failure(Error)
}
