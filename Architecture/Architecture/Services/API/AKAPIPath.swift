//
//  AKAPIPath.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

fileprivate enum ProdServer: String {
    
    case example = "www.google.com"
    
}

fileprivate enum PredProdServer: String {
    
    case example = "www.google.com"
    
}

enum AKAPIPath {
    
    case example
    
    var rawValue: String {
        switch self {
        case .example: return isReleaseAPI ? PredProdServer.example.rawValue : ProdServer.example.rawValue
        }
    }
    
}

enum RESTPath: String {
    
    case example = "/search"

}
