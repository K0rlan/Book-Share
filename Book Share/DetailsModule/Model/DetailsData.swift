//
//  DetailsData.swift
//  Dar Library
//
//  Created by Korlan Omarova on 03.03.2021.
//

import Foundation
import UIKit

enum DetailsData {
    case initial
    case loading
    case success(Data)
    case failure(Error)

    struct Data: Decodable {
        let id: Int
        let isbn: String
        let image: String?
        let title: String
        let author: String
        let publish_date: String
        let genre_id: Int
    }
}
