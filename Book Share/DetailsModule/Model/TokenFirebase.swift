//
//  TokenFirebase.swift
//  Book Share
//
//  Created by Korlan Omarova on 13.03.2021.
//

import Foundation

struct TokenFirebase {
    let  userID: String
    let  fcm: String
    
    init(dictionary: [String: Any]) {
        self.userID = dictionary["user_id"] as? String ?? ""
        self.fcm = dictionary["fcm_token"] as? String ?? ""
    }
}
