//
//  AKTheme.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UIColor {
    
    private class var style: AKThemeColorStyle { appThemeManager.colorStyle }
    
    // USAGE: - view.backgroundColor = .akWhite
    public class var akWhite: UIColor { style.akWhite }
    public class var akBlack: UIColor { style.akBlack }
    
}

protocol AKThemeColorStyle {
    
    var akWhite: UIColor { get }
    var akBlack: UIColor { get }
    
}

struct AKThemeColorStyleLight: AKThemeColorStyle {
    
    var akWhite: UIColor { UIColor.white }
    var akBlack: UIColor { UIColor.black }
    
}

struct AKThemeColorStyleDark: AKThemeColorStyle {
    
    var akWhite: UIColor { UIColor.black }
    var akBlack: UIColor { UIColor.white }
    
}

