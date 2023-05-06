//
//  AKRouter.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

let router = sharedInjector.router

class AKRouter {

    var currentNavigationController: UINavigationController? { UIApplication.shared.topViewController()?.navigationController }
    func addPreloader() {}
    func removePreloader() {}
    
}

extension AKRouter {
    
    func openExample(object: SimpleValueProtocol) {
        currentNavigationController?.showModel(model: ExampleModel(object: object))
    }
    
}
