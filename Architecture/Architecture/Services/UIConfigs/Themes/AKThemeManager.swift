//
//  AKThemeManager.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let appThemeManager = sharedInjector.themeManager

class AKThemeManager {
    
    init() {
        debugPrint("init theme manager")
    }
    
    private var savedTheme: Theme? = nil
    
    var appliedTheme: Theme {
        if savedTheme == nil { savedTheme = Theme() }
        return savedTheme!
    }
    
    var isLightTheme: Bool { theme is AKThemeLight }
    var isDarkTheme: Bool { theme is AKThemeDark }
    var theme: AKTheme { appliedTheme.getTheme }
    var imageStyle: AKThemeImageStyle { appliedTheme.imageStyle }
    var colorStyle: AKThemeColorStyle { appliedTheme.colorStyle }
    var rawValue: Int { savedTheme?.rawValue ?? .zero }
    
    func skipSavedTheme() {
        savedTheme = nil
    }
    
    func switchStyleToCurrent() {
        switchInterfaceStyle(to: sessionCache.currentThemeStyle == 0 ? .light : .dark)
    }
    
    func switchInterfaceStyle(to style: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = style
        }
    }
    
}

extension AKThemeManager {
    
    func apply(theme newTheme: Theme) {
        savedTheme = newTheme
        sessionCache.currentThemeStyle = newTheme.rawValue
//        custom ui redraw
//        updateUIWithoutRestart()
    }
    
    func updateUIWithoutRestart() {
        if let image = appDelegate.keyWindow?.snapShot, let window = appDelegate.keyWindow {
            let view = UIView(frame: UIScreen.main.bounds)
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = image
            view.addSubview(imageView)
            window.addSubview(view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5, animations: {
                    view.alpha = .zero
                }, completion: { _ in
                    view.removeFromSuperview()
                })
            }
        }
        uiService.applyUICOnfiguration()
//        viewControllers.forEach { $0.reloadViewFromNib() }
    }
    
}

extension AKThemeManager {
    
    enum Theme: Int, CaseIterable {
        
        case light = 0
        case dark = 1
        case system = 2
        
        init() {
            switch sessionCache.currentThemeStyle {
            case 0: self = .light
            case 1: self = .dark
            default: self = UIScreen.main.traitCollection.userInterfaceStyle == .light ? .light : .dark
            }
            appThemeManager.switchInterfaceStyle(to: sessionCache.currentThemeStyle == 0 ? .light : .dark)
        }
        
        var getTheme: AKTheme {
            switch self {
            case .light: return AKThemeLight()
            case .dark: return AKThemeDark()
            case .system: return UIScreen.main.traitCollection.userInterfaceStyle == .light ? AKThemeLight() : AKThemeDark()
            }
        }
        
        var imageStyle: AKThemeImageStyle {
            switch self {
            case .light: return AKThemeImageStyleLight()
            case .dark: return AKThemeImageStyleDark()
            case .system: return UIScreen.main.traitCollection.userInterfaceStyle == .light ? AKThemeImageStyleLight() : AKThemeImageStyleDark()
            }
        }
        
        var colorStyle: AKThemeColorStyle {
            switch self {
            case .light: return AKThemeColorStyleLight()
            case .dark: return AKThemeColorStyleDark()
            case .system: return UIScreen.main.traitCollection.userInterfaceStyle == .light ? AKThemeColorStyleLight() : AKThemeColorStyleDark()
            }
        }
        
        var themeName: String {
            switch self {
            case .light: return "light"
            case .dark: return "dark"
            case .system: return UIScreen.main.traitCollection.userInterfaceStyle == .light ? "light" : "dark"
            }
        }
        
    }
    
}
