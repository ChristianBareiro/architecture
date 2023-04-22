//
//  UIApplicationEx.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func topViewController(_ viewController: UIViewController? = appDelegate.window?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController { return topViewController(nav.visibleViewController) }
        if let presented = viewController?.presentedViewController { return topViewController(presented) }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController { return topViewController(selected) }
        }
        return viewController
    }
    
}
