//
//  RolesFirebase.swift
//  Book Share
//
//  Created by Korlan Omarova on 11.03.2021.
//

import Foundation

struct Roles {
    let  userID: String
    let  role: String
    
    init(dictionary: [String: Any]) {
            self.userID = dictionary["user_id"] as? String ?? ""
            self.role = dictionary["role"] as? String ?? ""
    }
}
