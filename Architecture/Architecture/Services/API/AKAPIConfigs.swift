//
//  AKAPIConfigs.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

struct AKAPIConfigs {
    
    static var timeoutInterval: Double = 60
    static var maxAttempts: Int = 3
    static var headers: [String: String] {
        var dictionary: [String: String] = [:]
        dictionary["Content-Type"] = "application/json"
        dictionary["Accept"] = "application/json"
        dictionary["Connection"] = "Upgrade"
        dictionary["Content-Encoding"] = "gzip"
        dictionary["User-Agent"] = ""
        dictionary["User-Data"] = ""
        return dictionary
    }

}
