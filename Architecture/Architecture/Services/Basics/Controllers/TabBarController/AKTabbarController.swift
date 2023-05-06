//
//  AKTabbarController.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class AKTabBarController: UITabBarController, UITabBarControllerDelegate {

    var tabBarView: AKTabBar!
    deinit {
        print("tabbarcontroller freed")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sessionCache.mTabbarController = self
        hidesBottomBarWhenPushed = true
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarSettings()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.isHidden = true
    }
    
    // MARK: - Helper methods

    private func addObservers() {
        print("add observers")
    }
    
    private func tabBarSettings() {
        tabBar.isHidden = true
        guard let _ = tabBarView else { instantiateTabBar(); return }
    }
    
    private func instantiateTabBar() {
        let inset = kTabBarHeight
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - inset, width: UIScreen.main.bounds.width, height: inset)
        tabBarView = AKTabBar.configure(with: frame, inset: kDefaultBottomSpace)
        tabBarView.itemSelected = {[weak self] index in
            guard let self = self else { return }
            self.tabBar.isHidden = true
            if self.selectedIndex == index { (self.viewControllers?[index] as? AKNavigationController)?.popToMainModel() }
            else { self.selectedIndex = index }
        }
        view.addSubview(tabBarView)
        view.bringSubviewToFront(tabBarView)
    }
    
    public func hideBottomBar(_ hide: Bool) {
        hideBottomBar(shouldHide: hide, animated: false)
    }
    
    public func hideBottomBar(shouldHide: Bool, animated: Bool = true) {
        var frame = tabBarView.frame
        frame.origin.y = shouldHide ? UIScreen.main.bounds.height : UIScreen.main.bounds.height - kTabBarHeight
        UIView.animate(withDuration: animated ? kTransformDuration : .zero) { [weak self] in
            self?.tabBarView.frame = frame
        }
    }
    
    func selectItem(at index: Int) {
        tabBarView.selectItem(at: index)
    }
    
    func reloadTabbar() {
        tabBarView.removeFromSuperview()
        tabBarView = nil
        instantiateTabBar()
    }
    
}
