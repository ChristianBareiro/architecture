import UIKit

class CircularAnimation: AKAnimation {

    private let lineWidth: CGFloat = 1.5
    private let duration: TimeInterval = 0.7
    private let animationContainer: UIView = UIView()

    var currentIndex: Int = 0

    private lazy var radius: CGFloat = {
        return (animationContainer.frame.height - 15) / 2
    }()
    private lazy var itemWidth: CGFloat = {
        return animationContainer.frame.width / CGFloat(tabBar.items?.count ?? 1)
    }()

    override func customInit() {
        animationContainer.backgroundColor = .clear
        animationContainer.isUserInteractionEnabled = false
        animationContainer.frame = tabBar.bounds
        tabBar.addSubview(animationContainer)
    }

    private func centerAt(_ index: Int) -> CGPoint {
        return CGPoint(x: itemWidth * CGFloat(index) + itemWidth / 2, y: animationContainer.frame.height / 2 - 5)
    }

    override func animate(to index: Int) {
        if index == currentIndex { return }

        let layer = CAShapeLayer()

        let block: () -> () = {
            layer.removeFromSuperlayer()
            layer.removeAllAnimations()
            self.currentIndex = index
        }

        let bezierPath = UIBezierPath()

        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = lineWidth

        let isClockWise = index < currentIndex
        let circumference, distanceBetweenTabs, totalLength: Double
        let centerDestination = centerAt(index)
        let centerOrigin = centerAt(currentIndex)
        bezierPath.addArc(withCenter: centerOrigin, radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: isClockWise)
        bezierPath.addArc(withCenter: centerOrigin, radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi / 2), clockwise: isClockWise)
        
        let origin = CGPoint(x: centerOrigin.x, y: animationContainer.frame.height - 12.5)
        let destination = CGPoint(x: centerDestination.x, y: animationContainer.frame.height - 12.5)
        bezierPath.move(to: origin)
        bezierPath.addLine(to: destination)

        bezierPath.addArc(withCenter: centerDestination, radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: isClockWise)
        bezierPath.addArc(withCenter: centerDestination, radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi / 2), clockwise: isClockWise)

        circumference = 2 * .pi * Double(radius * 2) / 2.0 + Double(lineWidth)
        distanceBetweenTabs = Double(abs(origin.x - destination.x))
        totalLength = 2 * circumference + distanceBetweenTabs
        layer.path = bezierPath.cgPath

        let leadingAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        leadingAnimation.duration = duration
        leadingAnimation.fromValue = 0
        leadingAnimation.toValue = 1
        leadingAnimation.isRemovedOnCompletion = false
        leadingAnimation.fillMode = CAMediaTimingFillMode.forwards
        leadingAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        let trailingAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
        trailingAnimation.duration = duration - 0.15
        trailingAnimation.fromValue = 0
        trailingAnimation.toValue = (circumference + distanceBetweenTabs) / totalLength
        trailingAnimation.isRemovedOnCompletion = false
        trailingAnimation.fillMode = CAMediaTimingFillMode.forwards
        trailingAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        CATransaction.begin()
        let transitionAnimationGroup = CAAnimationGroup()
        transitionAnimationGroup.animations = [leadingAnimation, trailingAnimation]
        transitionAnimationGroup.duration = duration
        transitionAnimationGroup.isRemovedOnCompletion = false
        transitionAnimationGroup.fillMode = CAMediaTimingFillMode.forwards
        CATransaction.setCompletionBlock(block)
        layer.add(transitionAnimationGroup, forKey: nil)
        CATransaction.commit()

        animationContainer.layer.addSublayer(layer)
    }

}
