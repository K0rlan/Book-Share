//
//  ViewData.swift
//  Dar Library
//
//  Created by Korlan Omarova on 26.02.2021.
//

import Foundation
import UIKit

enum ViewData {
    case initial
    case loading
    case successWithGenres([String:[Data]])
    case success([Data])
    case failure

    struct Data {
        let id: Int
        let image: UIImage?
        let title: String
        let author: String
        let publishDate: String
        let genre: String
    }
}

