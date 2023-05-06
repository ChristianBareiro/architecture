//
//  AKNotificatedViewController.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

class AKNotificatedViewController: UIViewController {

    var model: AKRouterModel? = nil {
        didSet {
            print("deinit \(self)")
        }
    }
    var disposeBag: DisposeBag = DisposeBag()
    var canSwipeGesture: Bool = true

    private var isEnabledPopGesture: Bool {
        return navigationController?.viewControllers.count ?? .zero > 1 ? canSwipeGesture : false
    }
    
    static func controller<T: AKNotificatedViewController>(storyboardName: String = "Main", identifier: String = "container") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    deinit {
        print("deinit \(self)")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .akWhite
    
        listenToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageTabBar(for: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabledPopGesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        if let vc = UIApplication.shared.topViewController() { manageTabBar(for: vc) }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return appThemeManager.isLightTheme ? .darkContent : .lightContent
        } else {
            return appThemeManager.isLightTheme ? .default : .lightContent
        }
    }
    
    func addLoader() {
        router.addPreloader()
    }
    
    func removeLoader() {
        router.removePreloader()
    }
    
    func hideNavigationBar(animated: Bool) {
        router.currentNavigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func listenToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) { }
    @objc func keyboardWillHide(notification: NSNotification) { }
    
    func animateConstraints(duration: TimeInterval = kTransformDuration) {
        UIView.animate(withDuration: duration, animations: { [weak self] in self?.view.layoutIfNeeded() })
    }
    
    private func manageTabBar(for vc: UIViewController) {
        // do smth with tabbar if needed
        // hide/show for example for certain controllers
    }

}
