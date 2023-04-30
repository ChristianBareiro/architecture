//
//  AKNavigationController.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class InteractiveNavigationController: UINavigationController {

}

class AKNavigationController: InteractiveNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
}

extension UINavigationController {
    
    func show(controller: AKNotificatedViewController, animated: Bool = true) {
        pushViewController(controller, animated: animated)
    }
    
    func present(controller: AKNotificatedViewController, animated: Bool = true, fullScreen: Bool = false, completion: (() -> ())? = nil) {
        if fullScreen { modalPresentationStyle = .fullScreen }
        present(controller, animated: animated, completion: completion)
    }
    
    func presentTabBar() {
        let storyboard = UIStoryboard(name: "ABMain", bundle: nil)
        let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabbar")
        tabbarController.modalPresentationStyle = .fullScreen
        present(tabbarController, animated: true, completion: nil)
    }
    
    func showModel(model: AKRouterModel, animated: Bool = true) {
        let controller = AKNotificatedViewController.controller()
        controller.model = model
        show(controller: controller, animated: animated)
    }
    
    func presentModel(model: AKRouterModel, animated: Bool = true, fullScreen: Bool = false) {
        let storyboard = UIStoryboard(name: "ABMain", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "navigation") as? AKNavigationController
        let controller = AKNotificatedViewController.controller()
        controller.model = model
        nvc?.viewControllers = [controller]
        if fullScreen { nvc?.modalPresentationStyle = .fullScreen }
        present(nvc!, animated: animated, completion: nil)
    }
    
    func popCurrentModel(animated: Bool = true) {
        popViewController(animated: animated)
    }
    
    func dismissCurrentModel(animated: Bool = true, completion: (() ->())? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    func popToMainModel(animated: Bool = true) {
        popToRootViewController(animated: true)
    }
    
    func removeAllModels(ofType type: Any.Type) {
        let vcs = viewControllers.filter { item in
            let model = (item as? AKContainerViewController)?.model
            if model == nil { return true }
            let mirror = Mirror(reflecting: model!)
            return mirror.subjectType != type
        }
        viewControllers = vcs
    }

}
