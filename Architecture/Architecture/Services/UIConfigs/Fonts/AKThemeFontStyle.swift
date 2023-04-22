//
//  AKThemeFontStyle.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UIFont {
    
    private class var style: AKThemeFontStyle { appFontManager.fontStyle }
    
    // USAGE: - lable.font = .regular14
    
    public class var regular10: UIFont { style.regular10 }
    public class var regular12: UIFont { style.regular12 }
    public class var regular14: UIFont { style.regular14 }
    public class var regular16: UIFont { style.regular16 }
   
    public class var medium16: UIFont { style.medium16 }
    public class var medium18: UIFont { style.medium18 }
    
    public class var bold20: UIFont { style.bold20 }
    public class var bold22: UIFont { style.bold22 }
    
}

protocol AKThemeFontStyle {
    
    // overriding this property you can dynamically change font size in your app
    // as is this parametr will be added to default font size
    var multiplier: CGFloat { get }
    
    // MARK: - regular
    
    var regular10: UIFont { get }
    var regular12: UIFont { get }
    var regular14: UIFont { get }
    var regular16: UIFont { get }

    // MARK: - medium
    
    var medium16: UIFont { get }
    var medium18: UIFont { get }
    
    // MARK: - bold

    var bold20: UIFont { get }
    var bold22: UIFont { get }
    
}

class AKFontStyleLarge: AKFontStyleDefault {
    
    override var multiplier: CGFloat { kLargeFontMultiplier }
    
}

class AKFontStyleDefault: AKThemeFontStyle {
    
    var multiplier: CGFloat { kRegularFontMultiplier }
    
    var regular10: UIFont { UIFont.systemFont(ofSize: 10 + multiplier) }
    var regular12: UIFont { UIFont.systemFont(ofSize: 12 + multiplier) }
    var regular14: UIFont { UIFont.systemFont(ofSize: 14 + multiplier) }
    var regular16: UIFont { UIFont.systemFont(ofSize: 16 + multiplier) }
   
    var medium16: UIFont { UIFont.systemFont(ofSize: 16 + multiplier, weight: .medium) }
    var medium18: UIFont { UIFont.systemFont(ofSize: 18 + multiplier, weight: .medium) }
    
    var bold20: UIFont { UIFont.systemFont(ofSize: 20 + multiplier, weight: .bold) }
    var bold22: UIFont { UIFont.systemFont(ofSize: 22 + multiplier, weight: .bold) }
    
}
