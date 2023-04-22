//
//  AKFontManager.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let appFontManager = sharedInjector.fontManager

class AKFontManager {
    
    private var savedFont: AKFont? = nil
    
    var appliedFont: AKFont {
        if savedFont == nil { savedFont = AKFont() }
        return savedFont!
    }
    
    var isLarge: Bool { fontStyle is AKFontStyleLarge }
    var fontStyle: AKThemeFontStyle { appliedFont.fontStyle }
    var rawValue: Int { savedFont?.rawValue ?? .zero }
    
}

extension AKFontManager {
    
    func apply(font newFont: AKFont) {
        savedFont = newFont
        sessionCache.currentFontStyle = newFont.rawValue
        appThemeManager.updateUIWithoutRestart()
    }
    
}

extension AKFontManager {
    
    enum AKFont: Int, CaseIterable {
        
        case usual = 0
        case large = 1
        
        init() {
            switch sessionCache.currentFontStyle {
            case 1: self = .large
            default: self = .usual
            }
        }
        
        var fontStyle: AKThemeFontStyle {
            switch self {
            case .usual: return AKFontStyleDefault()
            case .large: return AKFontStyleLarge()
            }
        }
        
        var fontName: String {
            switch self {
            case .usual: return "usual"
            case .large: return "large"
            }
        }
        
    }
    
}

