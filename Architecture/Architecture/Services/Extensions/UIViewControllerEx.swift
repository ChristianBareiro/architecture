//
//  UIViewControllerEx.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

typealias SuccessHandler = (Bool) -> ()

extension UIViewController: UIGestureRecognizerDelegate {}
extension UIViewController {
    
    @objc func loadMore(_ block: @escaping SuccessHandler) {}

    @objc func refreshData(_ block: @escaping SuccessHandler) {}
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func statusBarColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: appDelegate.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = color
            statusBar.tag = 100
            appDelegate.window?.addSubview(statusBar)
        } else {
            let statusBar = appDelegate.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
    
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view)
    }
    
}
