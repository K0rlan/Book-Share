//
//  ReservedBooksViewData.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import UIKit

enum ReservedBooksViewData {
    case initial
    case loading
    case success([Data])
    case failure
    
    struct Data {
        let image: UIImage?
        let title: String
        let author: String
        let publishDate: String
        let genre: String
    }
}
