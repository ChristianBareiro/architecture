//
//  UIScrollViewEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//
import UIKit

enum ScrollDirection {
    
    case left, right, up, down, crazy
    
}

extension UIScrollView {
    
    func bindToKeyboard() {
        addObservers()
    }
    
    func unBindKeyboard() {
        removeObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if UIApplication.shared.topViewController() is UIAlertController { return }
        if let dictionary = notification.userInfo {
            let size = (dictionary[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            scrollIndicatorInsets = UIEdgeInsets(top: contentInset.top, left: 0, bottom: size.height, right: 0)
            contentInset = UIEdgeInsets(top: contentInset.top, left: 0, bottom: size.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide() {
        if UIApplication.shared.topViewController() is UIAlertController { return }
        let inset = UIEdgeInsets(top: contentInset.top, left: 0, bottom: (UIApplication.shared.topViewController() as? AKContainerViewController)?.bottomInset ?? 0, right: 0)
        scrollIndicatorInsets = inset
        contentInset = inset
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
