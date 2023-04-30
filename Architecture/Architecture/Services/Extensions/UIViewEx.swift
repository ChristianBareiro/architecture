//
//  UIViewEx.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

enum GradientDirection: Equatable {

    case horizontal
    case vertical
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center([NSNumber])
    case radial

    var startPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 0, y: 0)
        case .vertical: return CGPoint(x: 0, y: 0)
        case .topLeft: return CGPoint(x: 0, y: 0)
        case .topRight: return CGPoint(x: 1, y: 0)
        case .bottomLeft: return CGPoint(x: 0, y: 1)
        case .bottomRight: return CGPoint(x: 1, y: 1)
        case .center: return CGPoint(x: 0.5, y: 0.5)
        case .radial: return CGPoint(x: 0.5, y: 0.5)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 1, y: 0)
        case .vertical: return CGPoint(x: 0, y: 1)
        case .topLeft: return CGPoint(x: 1, y: 1)
        case .topRight: return CGPoint(x: 0, y: 1)
        case .bottomLeft: return CGPoint(x: 1, y: 0)
        case .bottomRight: return CGPoint(x: 0, y: 0)
        case .center: return CGPoint(x: 1, y: 1)
        case .radial: return CGPoint(x: 0, y: -2)
        }
    }
    
    var locations: [NSNumber] {
        switch self {
        case .center(let array): return array
        default: return []
        }
    }

}


extension UIView {
    
    @IBInspectable open var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > .zero
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            guard let color = self.layer.borderColor else {
                return UIColor.clear
            }
            
            return UIColor(cgColor: color)
        }
    }
    
}

extension UIView {
    
    var snapShot: UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }
    
    func playBounceAnimation(duration: TimeInterval = 0.5) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func shake(vibration: AKVibration = .error) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        vibration.vibrate()
    }
    
    func jiggleAnimation(repeatCount: Float = Float.greatestFiniteMagnitude, duration: TimeInterval = kTransformDuration) {
        var iconShake = CABasicAnimation()
        iconShake = CABasicAnimation(keyPath: "transform.rotation.z")
        iconShake.fromValue = -0.1
        iconShake.toValue = 0.1
        iconShake.autoreverses = true
        iconShake.duration = duration
        iconShake.repeatCount = repeatCount
        self.layer.add(iconShake, forKey: "iconShakeAnimation")
    }
    
    @discardableResult
    func addGradient(colors: [CGColor], direction: GradientDirection) -> CAGradientLayer {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradient = CAShapeLayer.createGradient(colors: colors, direction: direction, bounds: bounds)
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @objc func hideKeyboard() { UIApplication.shared.topViewController()?.view.endEditing(true) }
    
}
