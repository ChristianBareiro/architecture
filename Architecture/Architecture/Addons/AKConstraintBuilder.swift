//
//  AKConstraintBuilder.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class AKConstraintBuilder: NSObject {
    
    open func setInsideConstraints(view: UIView, toView: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0, animated: Bool = false) {
        self.setSideConstraints(view: view, toView: toView, lValue: left, rValue: right, animated: animated)
        self.setTopSpace(view: view, toView: toView, value: top, animated: animated)
        self.setBottomSpace(view: view, toView: toView, value: bottom, animated: animated)
    }
    
    open func setSideConstraints(view: UIView, toView: UIView, lValue: CGFloat = 0, rValue: CGFloat = 0, animated: Bool = false) {
        self.setTrailConstraints(view: view, toView: toView, value: rValue, animated: animated)
        self.setLeadConstraints(view: view, toView: toView, value: lValue, animated: animated)
    }
    
    open func setTrailConstraints(view: UIView, toView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let trail = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: value)
        activate(constraints: [trail], animated: animated)
    }
    
    open func setLeadConstraints(view: UIView, toView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let lead = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: value)
        activate(constraints: [lead], animated: animated)
    }
    
    open func setTopSpace(view: UIView, toView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let top = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: value)
        activate(constraints: [top], animated: animated)
    }
    
    open func setBottomSpaceToMargin(view: UIView, toView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: value)
        activate(constraints: [bottom], animated: animated)
    }
    
    open func setBottomSpace(view: UIView, toView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: value)
        activate(constraints: [bottom], animated: animated)
    }
    
    open func setVerticalSpaceToUpperView(view: UIView, upperView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let topToUpper = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: upperView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: value)
        activate(constraints: [topToUpper], animated: animated)
    }
    
    open func setViewHeight(view: UIView, value: CGFloat = 0, animated: Bool = false) {
        let height = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        activate(constraints: [height], animated: animated)
    }
    
    open func setViewWidth(view: UIView, value: CGFloat = 0, animated: Bool = false) {
        let width = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        activate(constraints: [width], animated: animated)
    }
    
    open func setHorizontalSpace(leftView: UIView, rightView: UIView, value: CGFloat = 0, animated: Bool = false) {
        let spacerConstr = NSLayoutConstraint(item: rightView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: leftView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: value)
        activate(constraints: [spacerConstr], animated: animated)
    }
    
    open func setEqualWidth(view: UIView, toView: UIView, animated: Bool = false) {
        let widthConstr = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 1)
        activate(constraints: [widthConstr], animated: animated)
    }
    
    open func setEqualHeight(view: UIView, toView: UIView, animated: Bool = false) {
        let widthConstr = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 1)
        activate(constraints: [widthConstr], animated: animated)
    }
    
    open func setCenterY(view: UIView, toView: UIView, constant: CGFloat = 0, animated: Bool = false) {
        let centerYConstr = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: constant)
        activate(constraints: [centerYConstr], animated: animated)
    }
    open func setCenterX(view: UIView, toView: UIView, constant: CGFloat = 0, animated: Bool = false) {
        let centerXConstr = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: constant)
        activate(constraints: [centerXConstr], animated: animated)
    }
    
    private func activate(constraints: [NSLayoutConstraint], animated: Bool = false, viewIn: UIView? = nil) {
        NSLayoutConstraint.activate(constraints)
        UIView.animate(withDuration: animated ? 1 : 0) {[weak viewIn] in
            viewIn?.layoutIfNeeded()
        }
    }
    
}

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
    func setMultiplier(multiplier: CGFloat, priority2: UILayoutPriority? = nil) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = constraintWithMultiplier(multiplier)
        newConstraint.priority = priority2 ?? priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
}

