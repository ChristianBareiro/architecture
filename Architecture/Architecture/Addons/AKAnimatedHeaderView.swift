//
//  AKAnimatedHeaderView.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

final class FixAutoLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        if (preferredMaxLayoutWidth != bounds.size.width) { preferredMaxLayoutWidth = bounds.size.width }
        (superview?.superview as? SelfSizingView)?.reloadUI()
    }

}

class SelfSizingView: AKAnimatedHeaderView {
    
    var animationHeaderDuration: CGFloat = 0.3
    private var headerHeight: CGFloat = 0 {
        didSet {
            routerModel?.changeHeaderHeight(height: headerHeight, animated: true, duration: animationHeaderDuration)
        }
    }

    open func listenResize(from model: AKRouterModel?) {
        routerModel = model
        let height = sizeHeaderToFit(headerView: self)
        if height != headerHeight { headerHeight = height }
    }
    
    private func sizeHeaderToFit(headerView: UIView?) -> CGFloat {
        guard let headerView = headerView else { return 0.0 }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    func reloadUI() {
        guard let model = routerModel else { return }
        listenResize(from: model)
    }

}

class AKAnimatedHeaderView: UIView {
    
    deinit {
        routerModel = nil
    }
    
    var customMinHeight: CGFloat? { return nil }
    var ignoreHeaderAnimation: Bool = false
    var isPrepare: Bool = false

    private lazy var min: CGFloat = {
        return customMinHeight ?? ((routerModel?.navigationController?.viewControllers.last as? AKContainerViewController)?.topViewMinHeight ?? kMinExpandHeight)
    }()
    private lazy var max: CGFloat = {
        return ((routerModel?.navigationController?.viewControllers.last as? AKContainerViewController)?.topViewMaxHeight ?? kMinExpandHeight)
    }()
    private var speed: CGFloat { max == min ? 1 : 1 / (max - min) }
    weak var routerModel: AKRouterModel? = nil

    open func listenToScroll(from model: AKRouterModel?) {
        routerModel = model
        routerModel?.constructor?.headerScrollHandler = {[weak self] scrollView in
            if self?.routerModel?.constructor?.tableView.isHidden == true { return }
            self?.countSpeed(from: scrollView.contentOffset.y)
        }
        routerModel?.constructor2?.headerScrollHandler = {[weak self] scrollView in
            if self?.routerModel?.constructor2?.collectionView?.isHidden == true { return }
            self?.countSpeed(from: scrollView.contentOffset.y)
        }
    }
    
    private func countSpeed(from offset: CGFloat) {
        if ignoreHeaderAnimation { return }
        if !isPrepare { isPrepare = true; prepareToScroll() }
        let value = max - offset
        let recountedValue = value > max ? max : value < min ? min : value
        let result = recountedValue - min
        routerModel?.changeHeaderHeight(height: speed * result * (max - min) + min, animated: false)
        scrollOffsetChanged(progress: speed * result)
    }
    
    func passOffset(_ offset: CGFloat) {
        countSpeed(from: offset)
    }
    
    func scrollOffsetChanged(progress: CGFloat) {
        // override this func in your header to get progress value
        // progress in 0...1, where
        // 1 - full max height
        // 0 - min height
    }
    
    func prepareToScroll() {
      
    }
}

