//
//  APIImage.swift
//  Book Share
//
//  Created by Korlan Omarova on 07.03.2021.
//

import Foundation
import Moya

enum APIImage {
    case getImage(imageName: String)
    
}

extension APIImage: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://dev-darmedia-uploads.s3.eu-west-1.amazonaws.com/")!
    }
    
    var path: String {
        switch self {
        case .getImage(let imageName):
            return "\(imageName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case  .getImage:
            return .get
      
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getImage:
            return .requestPlain
      
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

