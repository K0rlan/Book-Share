//
//  Profile.swift
//  Dar Library
//
//  Created by Korlan Omarova on 27.02.2021.
//

import Foundation
import UIKit

enum UserProfile {
    case initial
    case loading
    case success(Data)
    case failure
    
    struct Data {
        let image: UIImage?
        let name: String
        let surname: String
        let email: String
        let phone: Int
    }
}
