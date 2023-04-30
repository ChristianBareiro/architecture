//
//  AKSessionCache.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let sessionCache = sharedInjector.sessionCache

class AKSessionCache {

    init() { debugPrint("init session cache") }
    
    private let kCurrentThemeStyle = "app.currentThemeStyle"
    var currentThemeStyle: Int {
        set { UserDefaults.standard.set(newValue, forKey: kCurrentThemeStyle) }
        get { UserDefaults.standard.integer(forKey: kCurrentThemeStyle) }
    }
    
    private let kCurrentFontSize = "app.currentFontSize"
    var currentFontStyle: Int {
        set { UserDefaults.standard.set(newValue, forKey: kCurrentFontSize) }
        get { UserDefaults.standard.integer(forKey: kCurrentFontSize) }
    }
    
    var currentLocalization: String {
        get { return NSLocalizedString("current_localization", comment: "") }
    }
    
}
