//
//  Utils.swift
//  Book Share
//
//  Created by Korlan Omarova on 04.03.2021.
//

import Foundation
import Griffon_ios_spm
import Griffon_ios_spm

class Utils {
    static func isExpDate() -> Bool{
        let idToken = Griffon.shared.idToken
        if let token = idToken {
            var payload64 = token.components(separatedBy: ".")[1]
            
            while payload64.count % 4 != 0 {
                payload64 += "="
            }
            let payloadData = Data(base64Encoded: payload64,
                                   options:.ignoreUnknownCharacters)!
            let json = try! JSONSerialization.jsonObject(with: payloadData, options: []) as! [String:Any]
            let exp = json["exp"] as! Int
            let expDate = Date(timeIntervalSince1970: TimeInterval(exp))
            print(expDate)
            if (expDate < Date()) {
                return true
            }
            
        }
        return false
        
    }
}
