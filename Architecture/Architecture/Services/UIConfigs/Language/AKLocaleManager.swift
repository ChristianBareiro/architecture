//
//  AKLocaleManager.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import Foundation

struct AKLocaleManager {
    
    static var languageCode: String? {
        guard var splits = Locale.preferredLanguages.first?.split(separator: "-"), let first = splits.first else { return nil }
        guard 1 < splits.count else { return String(first) }
        splits.removeLast()
        return String(splits.joined(separator: "-"))
    }
    
    static var language: AKLanguage? {
        return AKLanguage(languageCode: languageCode)
    }
    
}
