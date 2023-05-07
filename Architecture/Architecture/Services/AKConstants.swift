//
//  AKConstants.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let kLargeFontMultiplier: CGFloat = 2
let kRegularFontMultiplier: CGFloat = .zero
let kTransformDuration: TimeInterval = 0.3

var hasPhysicalButton: Bool { kSafeBottomInset == 0 }
var safeAreaInsets: UIEdgeInsets { UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets ?? .zero }
let kMaxExpandHeight: CGFloat = 384
let kMinExpandHeight: CGFloat = kFullHeaderHeight + safeAreaInsets.top - 20// 136
let kCornerRadius20: CGFloat = 20
let kCornerRadius25: CGFloat = 25
let kTopViewHeight: CGFloat = hasPhysicalButton ? 66 : 96.0
let kCuttedHeaderHeight: CGFloat = 55
let kFullHeaderHeight: CGFloat = 96
let kDefaultSideSpace: CGFloat = 16
let kDefaultBottomSpace: CGFloat = hasPhysicalButton ? kDefaultSideSpace / 2 : 28.0
let kTabBarHeight: CGFloat = hasPhysicalButton ? 64 : 84.0
var kSafeBottomInset: CGFloat { safeAreaInsets.bottom }

let kFakeInfiniteValue: Int = 10000

let kAPIRequestRef = "request_ref"
let kPreloader = "activity_indicator"

var isReleaseAPI: Bool = false

func classFromString(_ className: String) -> AnyClass? {
    if className.isEmpty { return nil }
    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    if let cls = NSClassFromString("\(namespace).\(className)") { return cls }
    return classFromString(String(className.dropLast()))
}

class AKWaitInfo: Info {
    
    override init() {
        super.init()
        sectionInfo = [waitSection()]
    }
    
    private func waitSection() -> HFSuperClass {
        var section = HFSuperClass()
        section.header = HeaderFooter(size: CGSize(width: .zero, height: kDefaultSideSpace))
        section.data = [CellSuperClass(id: .preloader)]
        return section
    }
    
}

class AKWaitInfo2: Info {
    
    override init() {
        super.init()
        sectionInfo = [waitSection()]
    }
    
    private func waitSection() -> HFSuperClass {
        var section = HFSuperClass()
        section.header = HeaderFooter(size: CGSize(width: .zero, height: kDefaultSideSpace))
        section.data = [CellSuperClass(id: .cLoader, cellSize: CGSize(width: .zero, height: kCuttedHeaderHeight))]
        return section
    }
    
}
