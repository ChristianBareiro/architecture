//
//  AKThemeImageStyle.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UIImage {
    
    // USAGE: - imageView.image = .example
    
    public class var example: UIImage? { StyledImage.example }
    
}

class StyledImage {
    
    private class var style: AKThemeImageStyle { appThemeManager.imageStyle }
    
    open class var example: UIImage? { style.image }
    
}

protocol AKThemeImageStyle {
    
    var image: UIImage? { get }
    
}

class AKThemeImageStyleLight: AKThemeImageStyle {
    
    var image: UIImage? { UIImage(named: "image_for_light_theme") }

}

class AKThemeImageStyleDark: AKThemeImageStyle {
    
    var image: UIImage? { UIImage(named: "image_for_dark_theme") }
    
}
