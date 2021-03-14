//
//  ViewImages.swift
//  Book Share
//
//  Created by Korlan Omarova on 08.03.2021.
//

import Foundation
import UIKit

enum ViewImages {
    case initial
    case loading
    case successImage([BooksImages])
    case failure(Error)
    
    struct BooksImages: Decodable {
        var id: Int
        var image: Data?
    }
   
}

