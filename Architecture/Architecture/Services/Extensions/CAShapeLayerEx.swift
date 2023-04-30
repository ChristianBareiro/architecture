//
//  CAShapeLayerEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    static func createGradient(colors: [CGColor], direction: GradientDirection, bounds: CGRect) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        let locations = direction.locations
        if locations.count > 0 {
            gradient.locations = locations
            gradient.type = CAGradientLayerType.radial
        }
        if direction == .radial { gradient.type = CAGradientLayerType.conic }
        return gradient
    }
    
}
