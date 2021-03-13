//
//  RentModel.swift
//  Book Share
//
//  Created by Korlan Omarova on 13.03.2021.
//

import Foundation

enum RentModel {
    case initial
    case loading
    case success([BookRent])
    case failure(Error)
    
}
