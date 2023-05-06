//
//  AKUIService.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let uiService = sharedInjector.uiService

class AKUIService {

    init() {
        debugPrint("init ui models")
        applyUICOnfiguration()
    }
    
    func applyUICOnfiguration() {
        UITextField.appearance().tintColor = .akBlack
        UITextView.appearance().tintColor = .akBlack
        UITextField.appearance().keyboardAppearance = appThemeManager.isLightTheme ? .light : .dark
        UIApplication.shared.topViewController()?.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            appDelegate.keyWindow?.overrideUserInterfaceStyle = appThemeManager.isDarkTheme ? .dark : .light
        }
    }
    
}
