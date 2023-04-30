//
//  AKLanguage.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import Foundation

enum AKLanguage: Equatable, CaseIterable {
    
    static var allCases: [AKLanguage] = [ukrainian, english(English.us)]
    
    case russian
    case ukrainian
    case english(English)

    enum English {
        case us
        case uk
        case australian
        case canadian
        case indian
    }

}

extension AKLanguage {

    var code: String {
        switch self {
        case .english(let english):
            switch english {
            case .us: return "en"
            case .uk: return "en-GB"
            case .australian: return "en-AU"
            case .canadian: return "en-CA"
            case .indian: return "en-IN"
            }
        case .russian: return "ru"
        case .ukrainian: return "uk"
        }
    }

    var name: String {
        switch self {
        case .english(let english):
            switch english {
            case .us: return "English"
            case .uk: return "English (UK)"
            case .australian: return "English (Australia)"
            case .canadian: return "English (Canada)"
            case .indian: return "English (India)"
            }
        case .russian: return "Русский"
        case .ukrainian: return "Українська"
        }
    }
   
    var localName: String {
        switch self {
        case .ukrainian: return AKLocalizedString("local_uk", comment: "")
        case .russian: return AKLocalizedString("local_ru", comment: "")
        case .english: return AKLocalizedString("local_us", comment: "")
        }
    }
    
    var shortName: String {
        switch self {
        case .ukrainian: return AKLocalizedString("short_uk_title", comment: "")
        case .russian: return AKLocalizedString("short_rus_title", comment: "")
        case .english: return AKLocalizedString("short_eng_title", comment: "")
        }
    }
}

extension AKLanguage {

    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en", "en-US": self = .english(.us)
        case "en-GB": self = .english(.uk)
        case "en-AU": self = .english(.australian)
        case "en-CA": self = .english(.canadian)
        case "en-IN": self = .english(.indian)
        case "ru": self = .russian
        case "uk": self = .ukrainian
        default: return nil
        }
    }
    
}
